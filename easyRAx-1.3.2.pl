#!/usr/bin/perl
# Author: Guy Leonard, Copyright 2010
$version = "1.3.2";

# Date: 2010-04-07
# This work is licenced under the Creative Commons Attribution-Non-Commercial-Share Alike 3.0 Unported License.
# To view a copy of this licence, visit http://creativecommons.org/licenses/by-nc-sa/3.0/

use Cwd;
use Switch;
use File::Basename;

## Updates, * Change/Fix, + Addition, - Deletion
# + 2010-04-08 - Detect OS and number of processors on Mac OSX and situations where no OS is returned.
# * 2010-04-07 - Confidence values fixed with new RAxML version
# * 2009-08-28 - Started update for RAxML 7.2.2 - Many changes and additions.
# + 2009-07-06 - Inclusion for -g/-r options in bootstrapping only
# * 2009-07-06 - Finished section 5.2.1
# + 2009-07-06 - Included start/stop time output
# * 2009-07-06 - Changed menu structure
# + 2009-07-06 - Verbose Mode to turn off RAxML console output
# + 2009-07-02 - Started inclusion of manual sections 5.2.1 & 5.2.2.
# * 2009-03-25 - Fix for CPU prediction by Antonio Fernàndez-Guerra
# * 2009-03-25 - Fix for "Incorrect Menu Choice error" by Karl Nordström
# + 2008-07-15 - Switch to swap manually between pthreads and standard version.
# * 2008-06-26 - Moved bootstrap # selection to before BKL tree option - allows for automated analyses.
# * 2008-06-26 - Fixed bad comparison to get file/directory - caused problems selecting file/dir #0...
# * 2008-05-19 - Split "hard way" into three steps...
# + 2008-05-19 - Added prediction of multi-core machines to use PTHREADS version
# + 2008-05-16 - INCLUDES the "HARD WAY"!!!! :)

$working_directory = getcwd;
$verbose           = "Off";
$verb              = " > /dev/null";
$enabled           = "Off";
print `clear`, "\n";
&detect_multi_core;
&menu;

sub detect_multi_core {

     $os_name = $^O;

     if ( $os_name eq 'linux' ) {

          # Only tested with Linux (Ubuntu).

          $pprocs = `grep -i "physical id" /proc/cpuinfo | sort -u | wc -l | tr -d '\n'`;
          $lprocs = `grep -i "processor" /proc/cpuinfo | sort -u | wc -l | tr -d '\n'`;

     }
     elsif ( $os_name eq 'darwin' ) {
	  
	  # Only tested with OSX 10.4+ - will not work with < OSX 10.2
          $pprocs = `system_profiler | grep -i "Number Of Processors:" | tr -d '[aA-zZ]:[[:punct:]]:\n'`;
          $lprocs = `system_profiler | grep -i "Total Number Of Cores:" | tr -d '[aA-zZ]:[[:punct:]]:\n'`;

     }
     elsif ( $os_name eq 'MSWin32' ) {

          print "MS Windows is not currently supported.\n";

     }
     else {

          print "Please enter how many physical processors you have\n>:";
          $pprocs = 1; # Default
          chomp( $pprocs = <STDIN> );
          print "Please enter how many logical processors (dual core = 2 etc) you have\n>:";
          $lprocs = 1; # Default
          chomp( $lprocs = <STDIN> );
     }

     if ( $lprocs >= 2 ) {

          $raxml_ver   = "raxmlHPC-PTHREADS -T $lprocs ";
          $version_one = "PTHREADS";
          $version_two = "Standard";
     }
     else {
          print
            "You do not have a multi-core processor or we cannot identify more than 1 core.\nUsing the standard RAxML version.\n";
          $raxml_ver   = "raxmlHPC ";
          $version_one = "Standard";
          $version_two = "PTHREADS";
     }

   return $os_name;
}

sub print_time {
     my $time = shift;
     if ( $time eq "start" ) {
          $start_time = scalar localtime(time);
     }
     elsif ( $time eq "end" ) {
          $end_time = scalar localtime(time);
          print "Start Time = $start_time\n";
          print "  End Time = $end_time\n\n";
     }

}

sub menu {

     print "*****************************************************\n";
     print "                      ____      _          \n";
     print "  ___  __ _ ___ _   _|  _  \\   / \\   __  __\n";
     print " / _ \\/ _` / __| | | | |_) |  / _ \\  \\ \\/ /\n";
     print "|  __/ (_| \\__ \\ |_| |  _ <  / ___ \\  >  < \n";
     print " \\___|\\__,_|___/\\__, |_| \\_\\/_/   \\_\\/_/\\_\\\n";
     print "                |___\/ $version_one                 \n";
     print "|C|E|   $lprocs logical in $pprocs physical processor(s) detected\n";
     print "|E|M|             v$version © Guy Leonard & CEEM 2008-2009\n";
     print "$raxml_ver - $os_name\n";
     print "*****************************************************\n";
     print "1) Fasta to Phylip Conversion\t";

     print "2) Predict Substitution Model\n";
     print "\t\t\t\t3) Predict Substitution Model - Partitioned\n";

     print "'Fast & Easy'\n4) Bootstrap Only\t\t";
     print "5) BS and Maximum Likelihood\n\n";

     print "'Hard & Slow'\n";

     print "6) Initial Rearrangement\t9) Bootstrapping\n";
     print "7) Number of Categories\t\t10) Obtain Confidence Values\n";
     print "8) Best-Known Likelihood Tree\n\n";
     print "11) Options 8 - 10\t\t12) Options 6 - 10\n\n";

     print "S) SSE3 $enabled \t\t\tC) $version_one to $version_two\n";
     print "V) Verbose Output $verbose\t\tQ) Quit\n";

     print ">:";

     chomp( $menu_choice = <STDIN> );

     switch ($menu_choice) {

          case /C/i {

               if ( $version_one eq "PTHREADS" ) {
                    $raxml_ver   = "raxmlHPC ";
                    $version_one = "Standard";
                    $version_two = "PTHREADS";
                    print `clear`, "\n";
                    &menu;
               }
               elsif ( $version_one eq "Standard" ) {
                    $raxml_ver   = "raxmlHPC-PTHREADS -T $lprocs ";
                    $version_one = "PTHREADS";
                    $version_two = "Standard";
                    print `clear`, "\n";
                    &menu;
               }
               elsif ( $version_one eq "PTHREADS+SSE3" ) {
                    $raxml_ver   = "raxmlHPC ";
                    $version_one = "Standard";
                    $version_two = "PTHREADS";
                    $enabled     = "Off";
                    print `clear`, "\n";
                    &menu;
               }
               elsif ( $version_one eq "Standard+SSE3" ) {
                    $raxml_ver   = "raxmlHPC-PTHREADS -T $lprocs ";
                    $version_one = "PTHREADS";
                    $version_two = "Standard";
                    $enabled     = "Off";
                    print `clear`, "\n";
                    &menu;
               }
          }

          case /S/i {

               if ( $version_one eq "PTHREADS" ) {
                    $raxml_ver   = "raxmlHPC-PTHREADS-SSE3 -T $lprocs ";
                    $version_one = "PTHREADS+SSE3";
                    $enabled     = "On";
                    print `clear`, "\n";
                    &menu;
               }
               elsif ( $version_one eq "PTHREADS+SSE3" ) {
                    $raxml_ver   = "raxmlHPC-PTHREADS -T $lprocs ";
                    $version_one = "PTHREADS";
                    $enabled     = "Off";
                    print `clear`, "\n";
                    &menu;
               }
               elsif ( $version_one eq "Standard" ) {
                    $raxml_ver   = "raxmlHPC-SSE3 ";
                    $version_one = "Standard+SSE3";
                    $enabled     = "On";
                    print `clear`, "\n";
                    &menu;
               }
               elsif ( $version_one eq "Standard+SSE3" ) {
                    $raxml_ver   = "raxmlHPC ";
                    $version_one = "Standard";
                    $enabled     = "Off";
                    print `clear`, "\n";
                    &menu;
               }
          }

          case "1" {
               &print_time("start");
               &get_sequence_directory;
               &directory_menu;
               $file_type = "fasta";
               &get_file_names;
               &file_menu;
               $in_fasta_file = $menu_file;
               &fasta_to_phylip;
               &print_time("end");
          }
          case "2" {
               &print_time("start");
               &get_sequence_directory;
               &directory_menu;
               $file_type = "phylip";
               &get_file_names;
               &file_menu;
               $in_phylip_file = $menu_file;

               if ( -e $log_directory && -d $log_directory ) {

                    $cmd = "cp $sequence_directory\/$in_phylip_file $log_directory";
                    system($cmd);
                    $alignmentName = "$log_directory\/$in_phylip_file";
                    chdir($log_directory);
                    &substitution_model_prediction;
               }
               else {
                    mkdir( "$log_directory", 0755 );
                    $cmd = "cp $sequence_directory\/$in_phylip_file $log_directory";
                    system($cmd);
                    $alignmentName = "$log_directory\/$in_phylip_file";
                    chdir($log_directory);
                    &substitution_model_prediction;
               }
               chdir($working_directory);
               &print_time("end");
          }
          case "3" {
               &print_time("start");
               &get_sequence_directory;
               &directory_menu;
               $file_type = "phylip";
               &get_file_names;
               &file_menu;
               $in_phylip_file = $menu_file;
               $alignmentName  = "$log_directory\/$in_phylip_file";
               $file_type      = "part";
               &get_file_names;
               &file_menu;
               $partition = $menu_file;

               if ( -e $log_directory && -d $log_directory ) {

                    $cmd = "cp $sequence_directory\/$in_phylip_file $log_directory";
                    system($cmd);

                    $cmd = "cp $sequence_directory\/$partition $log_directory";

                    system($cmd);
                    chdir($log_directory);
                    &partition_model_prediction;
               }
               else {
                    mkdir( "$log_directory", 0755 );
                    $cmd = "cp $sequence_directory\/$in_phylip_file $log_directory";
                    system($cmd);

                    $cmd = "cp $sequence_directory\/$partition $log_directory";

                    system($cmd);
                    chdir($log_directory);
                    &partition_model_prediction;
               }
               chdir($working_directory);
               &print_time("end");
          }
          case "4" {
               &print_time("start");
               &get_sequence_directory;
               &directory_menu;
               $file_type = "phylip";
               &get_file_names;
               &file_menu;
               $in_phylip_file = $menu_file;
               $alignmentName  = "$sequence_directory\/$menu_file";
               chdir($sequence_directory);
               &option_g;
               &option_r;
               &bootstrap_search;
               chdir($working_directory);
               &print_time("end");
          }
          case "5" {
               &print_time("start");
               &get_sequence_directory;
               &directory_menu;
               $file_type = "phylip";
               &get_file_names;
               &file_menu;
               $in_phylip_file = $menu_file;
               $alignmentName  = "$sequence_directory\/$menu_file";
               chdir($sequence_directory);
               &option_g;
               &option_r;
               &bootstrap_ml_search;
               chdir($working_directory);
               &print_time("end");
          }
          case "6" {
               &print_time("start");
               &get_sequence_directory;
               &directory_menu;
               $file_type = "phylip";
               &get_file_names;
               &file_menu;
               $in_phylip_file = $menu_file;
               $alignmentName  = "$sequence_directory\/$menu_file";
               chdir($sequence_directory);
               &initial_rearrangements;
               chdir($working_directory);
               &print_time("end");
          }
          case "7" {
               print "*** Not currently Implemented - Coming Soon ***";
          }
          case "8" {
               &print_time("start");
               &get_sequence_directory;
               &directory_menu;
               $file_type = "phylip";
               &get_file_names;
               &file_menu;
               $in_phylip_file = $menu_file;
               $alignmentName  = "$sequence_directory\/$menu_file";
               chdir($sequence_directory);
               &bkl_tree;
               chdir($working_directory);
               &print_time("end");
          }
          case "9" {
               &print_time("start");
               &get_sequence_directory;
               &directory_menu;
               $file_type = "phylip";
               &get_file_names;
               &file_menu;
               print `clear`, "\n";
               $in_phylip_file = $menu_file;
               $alignmentName  = "$sequence_directory\/$menu_file";
               chdir($sequence_directory);
               print "\nPlease enter the number of bootstrap runs (default: 100)\n";
               print ">:";
               chomp( $num_runs = <STDIN> );

               if ( $num_runs le "0" ) {
                    print "\nUsing default value.\n";
                    $num_runs = "100";
               }
               &option_g;
               &option_r;
               &bootstrapping;
               chdir($working_directory);
               &print_time("end");
          }
          case "10" {
               &print_time("start");
               &get_sequence_directory;
               &directory_menu;
               $file_type = "phylip";
               &get_file_names;
               &file_menu;
               $in_phylip_file = $menu_file;
               $alignmentName  = "$sequence_directory\/$menu_file";
               chdir($sequence_directory);
               $bkl_directory = "$sequence_directory/bkl";
               $bs_directory  = "$sequence_directory/bs";
               &obtain_confidence_values;
               chdir($working_directory);
               &print_time("end");
          }
          case "11" {
               &print_time("start");
               &get_sequence_directory;
               &directory_menu;
               $file_type = "phylip";
               &get_file_names;
               &file_menu;
               $in_phylip_file = $menu_file;
               $alignmentName  = "$sequence_directory\/$menu_file";
               chdir($sequence_directory);
               print "\nPlease enter the number of bootstrap runs (default: 100)\n";
               print ">:";
               chomp( $num_runs = <STDIN> );

               if ( $num_runs le "0" ) {
                    print "\nUsing default value.\n";
                    $num_runs = "100";
               }
               &bkl_tree;
               &bootstrapping;
               &obtain_confidence_values;
               chdir($working_directory);
               &print_time("end");
          }
          case /Q/i {
               print `clear`, "\n";
               print "Goodbye...\n";
             last;
          }
          case /V/i {
               if ( $verbose == "Off" ) {
                    $verbose = "On";
                    $verb    = "";
                    print `clear`, "\n";
                    &menu;

               }
               elsif ( $verbose == "On" ) {
                    $verbose = "Off";
                    $verb    = " > /dev/null";
                    print `clear`, "\n";
                    &menu;
               }
          }
          else {
               print `clear`, "\n";
               print "Incorrect Selection - Please Try Again...\n\n";
               &menu;
          }
     }

}

sub get_sequence_directory {

     @all_files = glob("*");
     @folders;
     foreach my $item (@all_files) {
          if ( -d $item ) {    #Put all folders into array
               push( @folders, $item );
          }
     }
     $folder_num = @folders;
}

sub directory_menu {

     print "Directory File Menu\n";
     print "*******************\n";
     for ( $i = 0 ; $i < $folder_num ; $i++ ) {
          print "$i) $folders[$i]\n";
     }

     print "Please enter the number for the directory where your sequences are located.\n";
     print ">:";

     chomp( $menu_choice = <STDIN> );
     if (    $menu_choice >= $folder_num
          || $menu_choice < "0"
          || $menu_choice eq m/[a-z]/ ) {
          print `clear`, "\n";
          print "\nIncorrect Menu Choice!\n\n";
          $menu_choice = "";
          &directory_menu;

     }
     else {
          $sequence_directory = "$working_directory/$folders[$menu_choice]";
          $log_directory      = "$sequence_directory/logs";
     }
}

sub get_file_names {
     if ( -e $sequence_directory && -d $sequence_directory ) {
          @file_names = glob("$sequence_directory/*.$file_type");
          foreach my $file (@file_names) {

               $file = reverse $file;
               @fn   = split( /\//, $file );
               $file = reverse $fn[0];
          }
          $file_num = @file_names;
     }
     else {
          print `clear`, "\n";
          print "\nThere is no sequence directory, please create one.\n";
        last;
     }
}

sub file_menu {

     if ( $file_num < 1 ) {

          print `clear`, "\n";
          print
            "\nThere are no $file_type sequences in the directory, please make sure you have selected the right directory.\n";
        last;

     }
     else {
          print "$file_type File Menu\n";
          print "******************\n";
          for ( $i = 0 ; $i < $file_num ; $i++ ) {
               print "$i) $file_names[$i]\n";
          }

          print "Please enter the number for your sequence file.\n";
          print ">:";

          chomp( $menu_choice = <STDIN> );
          if (    $menu_choice >= $file_num
               || $menu_choice < 0
               || $menu_choice eq m/[a-z]/ ) {
               print `clear`, "\n";
               print "\nIncorrect Menu Choice!\n\n";
               $menu_choice = "";
               &file_menu;

          }
          else {
               $menu_file = $file_names[$menu_choice];
          }
     }
}

## Adapted from code, with permission, from the main RAxML website.
sub substitution_model_prediction {

     #print "\nStart = " . scalar localtime(time) . "\n";
     @AA_Models = (
                    "DAYHOFF",  "DCMUT",  "JTT",       "MTREV",  "WAG",  "RTREV",
                    "CPREV",    "VT",     "BLOSUM62",  "MTMAM",  "LG",   "GTR",
                    "DAYHOFFF", "DCMUTF", "JTTF",      "MTREVF", "WAGF", "RTREVF",
                    "CPREVF",   "VTF",    "BLOSUM62F", "MTMAMF", "LGF",  "GTRF"
     );

     print "\nBuilding Initial Parsimony Tree.\n";
     $cmd =
         $raxml_ver
       . "-y -m PROTCATJTT -s "
       . $alignmentName
       . " -n ST_"
       . $in_phylip_file
       . " \> ST_"
       . $in_phylip_file . "_out";

     #print($cmd);
     system($cmd);
     $numberOfModels = @AA_Models;
     print "Starting to optimise model parameters.\n";
     for ( $i = 0 ; $i < $numberOfModels ; $i++ ) {
          $aa = "PROTGAMMA" . $AA_Models[$i];
          $cmd =
              $raxml_ver
            . "-f e -m "
            . $aa . " -s "
            . $alignmentName
            . " -t RAxML_parsimonyTree.ST_"
            . $in_phylip_file . " -n "
            . $AA_Models[$i] . "_"
            . $in_phylip_file
            . "_EVAL \> "
            . $AA_Models[$i] . "_"
            . $in_phylip_file
            . "_EVAL.out"
            . $verb;

          #print($cmd);
          system($cmd);
          print "Optimising model $i of 20: $aa\n";
     }
     print "Completed optimising models.\n";
     print "Generating logs";
     for ( $i = 0 ; $i < $numberOfModels ; $i++ ) {
          $logFileName = "RAxML_log." . $AA_Models[$i] . "_" . $in_phylip_file . "_EVAL";

          #print $logFileName."\n";
          $lh[$i] = getLH($logFileName);
          print ".";
     }

     $bestLH = -1.0E300;
     $bestI  = -1;

     for ( $i = 0 ; $i < $numberOfModels ; $i++ ) {

          #print "\nModel: ".$AA_Models[$i]." LH: ". $lh[$i]."\n";
          if ( $lh[$i] > $bestLH ) {
               $bestLH = $lh[$i];
               $bestI  = $i;
          }
     }
     open my $OUTFILE, '>>', "$sequence_directory/best_model_$in_phylip_file.txt";
     print "\n\nBest Model : " . $AA_Models[$bestI] . "\n\n";
     print $OUTFILE "\n\nBest Model : " . $AA_Models[$bestI] . "\n\n";
     close($OUTFILE);

     $bestModel = $AA_Models[$bestI];
}

## Adapted from code, with permission, from the main RAxML website.
sub partition_model_prediction {

     print "How many parts to your alignment? (0-9)\n";
     print ">:";
     chomp( $count = <STDIN> );
     print "Splitting up multi-gene alignment\n";
     $cmd =
         $raxml_ver
       . "-f s -m PROTCATJTT -s "
       . $alignmentName . " -q "
       . $partition
       . " -n SPLIT_"
       . $in_phylip_file
       . " \> SPLIT_"
       . $in_phylip_file . "_out"
       . $verb;
     $alignment_temp = $alignmentName;
     $phylip_temp    = $in_phylip_file;

     system($cmd);
     for ( $x = 0 ; $x < $count ; $x++ ) {

          #print "\n\n$in_phylip_file . ".GENE." . $x\n\n";
          print "PARTITION: " . $x . "\n";
          $alignmentName  = $alignmentName . ".GENE." . $x;
          $in_phylip_file = $in_phylip_file . ".GENE." . $x;
          &substitution_model_prediction;
          $alignmentName  = $alignment_temp;
          $in_phylip_file = $phylip_temp;
     }

}

## Adapted from code from the main RAxML website.
sub getLH {
     my $fileID = $_[0];
     open( CPF, $fileID );
     my @lines = <CPF>;
     close(CPF);
     my $numIT  = @lines;
     my $lastLH = pop(@lines);
     my $k      = index( $lastLH, '-' );
     my $LH     = substr( $lastLH, $k );
   return $LH;
}

## Adapted from code from the main RAxML website.
sub getTIME {
     my $fileID = $_[0];
     open( CPF, $fileID );
     my @lines = <CPF>;
     close(CPF);
     my $numIT  = @lines;
     my $lastLH = pop(@lines);
     my $k      = index( $lastLH, '-' );
     my $TIME   = substr( $lastLH, 0, $k - 1 );
   return $TIME;
}

## Based on a script available from the author of RAxML
#  from http://icwww.epfl.ch/~stamatak/index-Dateien/Page443.htm
sub fasta_to_phylip {

     $out_fasta_file = " > " . $sequence_directory . "/" . $in_fasta_file . ".phylip";
     open( INFILE, " < " . "$sequence_directory/$in_fasta_file" );

     $taxa = -1;

     while ( $line = <INFILE> ) {
          if ( $line =~ />/ ) {
               $taxa++;
               $name = $line;
               $name =~ s/[\s+|\(|\)|\,|;]//g;
               $name =~ s/,//g;
               $name =~ s/>//g;
               $taxonNames[$taxa] = $name;
          }
          else {
               $seq = $line;
               $seq =~ s/\s+//g;
               $sequences[$taxa] = $sequences[$taxa] . $seq;
          }
     }

     close(INFILE);

     $s  = $taxa + 1;
     $bp = length( $sequences[0] );

     print "\nConverting";
     open( OUTFILE, $out_fasta_file );
     print OUTFILE $s . " " . $bp . "\n";

     for ( $i = 0 ; $i <= $taxa ; $i++ ) {
          print OUTFILE $taxonNames[$i] . " " . $sequences[$i] . "\n";
          print ".";
     }
     print "\nFile Converted$out_fasta_file\n";
}

sub model_selection {

     print "Binary, Nucleotide or AA Data?\n1) DNA\n2) Amino Acid\n3) Binary\n>:";
     chomp( $dna_or_aa = <STDIN> );
     if ( $dna_or_aa eq "1" ) {
          print "\nSubstitution Model\n1) GTR CAT\n2) GTR GAMMA\n>:";
          chomp( $model = <STDIN> );
          $model = "GTRCAT";
          if ( $model eq "1" ) {
               $model = "GTRCAT";
          }
          elsif ( $model eq "2" ) {
               $model = "GTRGAMMA";
          }
          print "\nEstimate proportion of invariable sites?\n1) Yes\n2) No\n>:";
          chomp( $base_freq = <STDIN> );
          if ( $base_freq eq "1" ) {
               $model = $model . "I";
          }
          $is_model_set = "true";
     }
     elsif ( $dna_or_aa eq "2" ) {
          $model = "PROTCAT";
          print "\nSubstitution Model\n1) PROT CAT\n2) PROT GAMMA\n>:";
          chomp( $model = <STDIN> );
          if ( $model eq "1" ) {
               $model = "PROTCAT";
          }
          elsif ( $model eq "2" ) {
               $model = "PROTGAMMA";
          }
          print "\nEstimate proportion of invariable sites? (Model + I)\n1) Yes\n2) No\n>:";
          chomp( $base_freq = <STDIN> );
          if ( $base_freq eq "1" ) {
               $model = $model . "I";
          }
          @aa_models = (
                         "DAYHOFF", "DCMUT", "JTT",      "MTREV", "WAG", "RTREV",
                         "CPREV",   "VT",    "BLOSUM62", "MTMAM", "LG",  "GTR"
          );
          $aa_num = @aa_models;
          print "\nWhich Amino Acid Model?\n";
          for ( $i = 0 ; $i < $aa_num ; $i++ ) {
               print "$i) $aa_models[$i]\n";
          }
          print ">:";
          chomp( $input_model = <STDIN> );
          $model = $model . "$aa_models[$input_model]";
          print "\nUse empirical base frequencies? (Model + F)\n1) Yes\n2) No\n>:";
          chomp( $base_freq = <STDIN> );
          if ( $base_freq eq "1" ) {
               $model = $model . "F";
          }
          $is_model_set = "true";
     }
     elsif ( $dna_or_aa eq "3" ) {
          print "\nSubstitution Model\n1) BIN CAT\n2) BIN GAMMA\n>:";
          chomp( $model = <STDIN> );
          $model = "BINCAT";
          if ( $model eq "1" ) {
               $model = "BINCAT";
          }
          elsif ( $model eq "2" ) {
               $model = "BINGAMMA";
          }
          print "\nEstimate proportion of invariable sites?\n1) Yes\n2) No\n>:";
          chomp( $base_freq = <STDIN> );
          if ( $base_freq eq "1" ) {
               $model = $model . "I";
          }
          $is_model_set = "true";

     }
     else {
          print `clear`, "\n";
          print "Incorrect selection. Please try again!";
          &model_selection;
     }

}

sub bootstrap_search {

     print "Please enter the number of runs (default: 100)\n";
     print ">:";
     chomp( $num_runs = <STDIN> );
     if ( $num_runs le "0" ) {
          print "\nUsing default value.\n";
          $num_runs = "100";
     }

     print "Please enter the substituion model (default: GTRMIX+Model or PROTMIX+Model)\n";
     &model_selection;
     print "Bootstrapping...\n";
     $cmd =
         $raxml_ver
       . "-x 12345 -p 12345 -N "
       . $num_runs . " -m "
       . $model
       . $option_g
       . $option_r . " -s "
       . $alignmentName . " -n "
       . $in_phylip_file . ".out"
       . $verb;

     system($cmd);

}

sub bootstrap_ml_search {

     print "Please enter the number of runs (default: 100)\n";
     print ">:";
     chomp( $num_runs = <STDIN> );
     if ( $num_runs le "0" ) {
          print "\nUsing default value.\n";
          $num_runs = "100";
     }

     #
     print "Please enter the substituion model (default: GTRMIX+Model or PROTMIX+Model)\n";
     &model_selection;
     print "Bootstrapping and ML...\n";
     $cmd =
         $raxml_ver
       . "-f a -x 12345 -p 12345 -N "
       . $num_runs . " -m "
       . $model
       . $option_g
       . $option_r . " -s "
       . $alignmentName . " -n "
       . $in_phylip_file . ".out"
       . $verb;

     system($cmd);
}

sub option_g {

     print "Would you like to load a multifurcating constraint tree?\n";
     print ">:";
     chomp( $choice = <STDIN> );
     if ( $choice =~ m/y/is ) {

          &directory_menu;
          $file_type = "phylip";
          &get_file_names;
          &file_menu;
          $multi_constraint_tree = "$sequence_directory\/$menu_file";
          $option_g              = " -g $multi_constraint_tree";
     }
     elsif ( $choice =~ m/n/is ) {
          print "No multifurcating constraint tree selected.\n";
          $option_g = "";
     }
     else {
          print `clear`, "\n";
          print "\nIncorrect selection, please try again.";
          &option_g;
     }

}

sub option_r {

     print "Would you like to load a bifurcating constraint tree?\n";
     print ">:";
     chomp( $choice = <STDIN> );
     if ( $choice =~ m/y/is ) {

          &directory_menu;
          $file_type = "phylip";
          &get_file_names;
          &file_menu;
          $bi_constraint_tree = "$sequence_directory\/$menu_file";
          $option_r           = " -r $bi_constraint_tree";
     }
     elsif ( $choice =~ m/n/is ) {
          print "No bifurcating constraint tree selected.\n";
          $option_r = "";
     }
     else {
          print `clear`, "\n";
          print "\nIncorrect selection, please try again.";
          &option_r;
     }

}

sub initial_rearrangements {
     print "Getting the Initial Rearrangement Settings\n";
     if ( $is_model_set eq "true" ) {
          print "\nModel already selected = $model\n";
     }
     else {
          &model_selection;
     }
     print "\nPlease enter number of Starting Trees (default: 10)\n";
     print ">:";
     chomp( $num_ST = <STDIN> );
     if ( $num_ST <= "0" ) {
          print "\nUsing default value of 10.\n";
          $num_ST = "10";
     }
     $irs_directory = "$sequence_directory/irs";

     if ( -e $irs_directory && -d $irs_directory ) {

          print "\nYou appear to have already run this...\n";
     }
     else {
          mkdir( "$irs_directory", 0755 );
          chdir($irs_directory);

          #
          print "Generating Starting Trees";
          for ( $x = 0 ; $x < $num_ST ; $x++ ) {
               $cmd =
                   $raxml_ver 
                 . "-y -m " 
                 . $model . " -s "
                 . $alignmentName . " -n "
                 . $in_phylip_file . ".ST$x"
                 . $verb;

               system($cmd);
               print ".";
          }

          #
          print "\nGenerating Fixed Inferences";
          for ( $x = 0 ; $x < $num_ST ; $x++ ) {
               $cmd =
                   $raxml_ver
                 . "-f d -i 10 -m "
                 . $model . " -s "
                 . $alignmentName
                 . " -t RAxML_parsimonyTree.$in_phylip_file.ST$x -n "
                 . $in_phylip_file . ".FI$x"
                 . $verb;

               system($cmd);
               print ".";
          }

          #
          print "\nGenerating Automatic Inferences";
          for ( $x = 0 ; $x < $num_ST ; $x++ ) {
               $cmd =
                   $raxml_ver
                 . "-f d -m "
                 . $model . " -s "
                 . $alignmentName
                 . " -t RAxML_parsimonyTree.$in_phylip_file.ST$x -n "
                 . $in_phylip_file . ".AI$x"
                 . $verb;

               system($cmd);
               print ".";
          }

          #
          $ir_fileName;
          $ir_value = 0;
          print "\n\nEvaluating Automatic Inferences";
          for ( $y = 0 ; $y < $num_ST ; $y++ ) {
               open my $FILE, '< ', "RAxML_log.$in_phylip_file.AI$y";
               my $last_line;
               while (<$FILE>) {
                    $last_line = $_ if eof;
               }

               $re1 = '([+-]?\\d*\\.\\d+)(?![-+0-9\\.])';    # Float 1
               $re2 = '(\\s+)';                              # White Space 1
               $re3 = '([+-]?\\d*\\.\\d+)(?![-+0-9\\.])';
               $re  = $re1 . $re2 . $re3;
               $last_line =~ m/$re/is;

               $likelihood_value = "$3\_AI$y";
               push( @likelihood_values, $likelihood_value );
               print ".";
               close($FILE);
          }

          #
          print "\nEvaluating Fixed Inferences";
          for ( $y = 0 ; $y < $num_ST ; $y++ ) {
               open my $FILE, '<', "RAxML_log.$in_phylip_file.FI$y";
               my $last_line;
               while (<$FILE>) {
                    $last_line = $_ if eof;
               }

               $re1 = '([+-]?\\d*\\.\\d+)(?![-+0-9\\.])';    # Float 1
               $re2 = '(\\s+)';                              # White Space 1
               $re3 = '([+-]?\\d*\\.\\d+)(?![-+0-9\\.])';
               $re  = $re1 . $re2 . $re3;
               $last_line =~ m/$re/is;

               $likelihood_value = "$3\_FI$y";
               push( @likelihood_values, $likelihood_value );
               print ".";
               close($FILE);
          }

          my @sorted_likelihoods = sort { $b <=> $a } @likelihood_values;

          @values = split( /\_/, $sorted_likelihoods[0] );
          if ( $values[1] =~ m/AI\d/ ) {
               print
                 "\nAutomatic Inference $values[1] yields the best likelhihood.\nLikelihood Value = $values[0]\n";
               open my $FILE, '<', "RAxML_info.$in_phylip_file.$values[1]";
               $re1 = '.*?';                             # Non-greedy match on filler
               $re2 = ' best rearrangement setting ';    # Command Seperated Values 1
               $re3 = '(\\d+)';
               $re  = $re1 . $re2 . $re3;
               while (<$FILE>) {
                    my ($line) = $_;
                    if ( $line =~ m/$re/is ) {
                         $i_value = "-i $1";
                         print "I = $i_value\n";
                    }
               }
               close($FILE);
          }
          else {
               print
                 "\n\nFixed Inference $values[1] yields the best likelhihood.\nLikelihood Value = $values[0]\n";
               $i_value = "-i 10";
          }

     }
     chdir($working_directory);
     print "\n";
}

sub bkl_tree {
     print "Finding the Best-Known Likelihood (BKL)\n";
     if ( $is_model_set eq "true" ) {
          print "\nModel already selected = $model\n";
     }
     else {
          &model_selection;
     }
     print "\nPlease enter number of inferences (default/min: 2)\n";
     print ">:";
     chomp( $num_infs = <STDIN> );
     if ( $num_infs < "2" ) {
          print "\nUsing default value of 2.\n";
          $num_infs = "2";
     }
     $bkl_directory = "$sequence_directory/bkl";

     if ( -e $bkl_directory && -d $bkl_directory ) {

          print "\nYou appear to have already run this...\n";
     }
     else {
          mkdir( "$bkl_directory", 0755 );
          chdir($bkl_directory);
          print "Generating BKL Trees...\n";
          $cmd =
              $raxml_ver
            . "-f d -f 12345 -m "
            . $model . " -s "
            . $alignmentName . " -N "
            . $num_infs . " -n "
            . $in_phylip_file . ".out"
            . $verb;

          print "\n\n$cmd\n\n";
          system($cmd);
     }
     chdir($working_directory);

}

sub bootstrapping {
     if ( $is_model_set eq "true" ) {
          print "\nModel already selected = $model\n";
     }
     else {
          &model_selection;
     }
     $bs_directory = "$sequence_directory/bs";

     ## This should be obsolete once/if I implement a 'run' system as per fdfBLAST...
     if ( -e $bs_directory && -d $bs_directory ) {

          print "\nYou appear to have already run this...\n";
     }
     else {
          mkdir( "$bs_directory", 0755 );
          chdir($bs_directory);
          $cmd =
              $raxml_ver
            . "-f d -m "
            . $model . " -s "
            . $alignmentName
            . $option_g
            . $option_r . " -N "
            . $num_runs . " -b "
            . "12345 -n "
            . $in_phylip_file . ".boot"
            . $verb;

          print "Bootstrapping...\n";
          system($cmd);
     }
     chdir($working_directory);
}

sub obtain_confidence_values {

     #$infofile = "$bkl_directory/RAxML_info.$in_phylip_file.out";
     #open my $INFOFILE, '<', "$infofile";

     #foreach my $line (<$INFOFILE>) {
     #     chomp($line);
     #     $txt = $line;
     #     $re1 = '.*?';       # Non-greedy match on filler
     #     $re2 = '(\\d+)';    # Integer Number 1
     #     $re3 = '(:)';       # Single Character 1

     #     $re = $re1 . $re2 . $re3;
     #     if ( $txt =~ m/$re/is ) {
     #          $int1 = $1;
     #          print "\nBest Scoring Tree found in RUN $int1 \n";
     #     }
     #}

     ## Best Scoring Tree is now contained in its own file...
     #  RAxML_bestTree.Phso108275.phylip.out

     if ( $is_model_set eq "true" ) {
          print "\nModel already selected = $model\n";
     }
     else {
          &model_selection;
     }

     ##
     $tree_directory = "$sequence_directory/tree";
     mkdir( "$tree_directory", 0755 );
     chdir($bs_directory);
     $cmd = "cp RAxML_bootstrap.$in_phylip_file.boot $tree_directory";
     system($cmd);
     chdir($bkl_directory);
     $cmd = "cp RAxML_bestTree.$in_phylip_file.out $tree_directory";
     system($cmd);
     chdir($tree_directory);

     print "\nObtaining Confidence Values...";
     $cmd =
         $raxml_ver
       . "-f b -m "
       . $model . " -s "
       . $alignmentName . " -z "
       . "RAxML_bootstrap."
       . $in_phylip_file
       . ".boot -t "
       . "RAxML_bestTree."
       . $in_phylip_file . ".out"
       . " -n final."
       . $in_phylip_file . ".tree"
       . $verb;

     #print "\n\n$cmd\n\n";
     system($cmd);
     unlink("RAxML_bootstrap.$in_phylip_file.boot");
     unlink("RAxML_bestTree.$in_phylip_file.out");

}
