Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287Ab0JFWyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 18:54:25 -0400
Received: from smh05.opentransfer.com ([98.130.1.173]:48352 "EHLO
	smh05.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932904Ab0JFWyY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 18:54:24 -0400
X-Opentransfer-Authenticated: rick@presidentbyamendment.com
Message-ID: <20101006181527.mcxt3p44t4c80ows@webmail.opentransfer.com>
Date: Wed, 06 Oct 2010 18:15:27 -0400
From: rick@presidentbyamendment.com
To: linux-kernel@vger.kernel.org
Subject: Comment on Cybersecurity, open OSen, and Stuxnet, to the NSA
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
X-Originating-IP: 205.201.255.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comment on Cybersecurity, open OSen, and Stuxnet, to the NSA

Hello NSA. I'm the first person ever banned from linux-kernel. I was banned
for spewing hackish off-topic stuff like a working stack machine interpreter
daemon, "Why the Plan 9 C compiler doesn't have asm("")", and a
packages-friendly internationalization of the file names tree. Appended
below is a trivial shell function that gets rid of make.

The worst threat to US cybersecurity is the plague of machines running
MSDoS+GUI on internetworked machines. Stuxnet, of course, attacks
Mickeysoft. That was buried deep in the news somewhere.  The NSA needs to
inform the world that A: people that write process control systems that
don't have a deadman switch to shut down peacefully if there isn't an
engineer on board are incompetent, (I personally turned down a badly needed
job once because I didn't want to be party to robotic lawnmowers) B: people
that write networked process control systems on Mickeysoft are incompetent.

C: the world needs a new client OS.

Last time I looked, Windows has a task manager, not a process manager.
Unfortunately, the free unix world is a bit too pompous and rigged to really
cater to end users. Trying to cater to leaf nodes made me a Linux-gnu pariah
with my cLIeNUX distro. Individualism is so Ugly American. So capitalist.
And truth be told, isn't in POSIX. Devout posixers, however, hate things
that aren't in POSIX even if they don't actually break POSIX. Not good for
progress on the client.  The Linux kernel clique basically ignored the
Forth-interpreter-in-kernelspace option when I implemented it for Linux.
There's no such thing in POSIX. Nor is there the concept of the one-person
privately owned computer. The kernel clique were also violently offended
when I made it possible to rename /bin in e.g. Hindi without breaking Linux
packages. I've seen more Google feedback on Dotted Standard File Hierarchy
on English-language Indian social sites than on Linux sites. And while Linux
posixers were sneering at such things, MacOS went to BSD. BSD as a Photoshop
platform, basically. The basic premise of Linux, time has shown, is rather
inane. Linux is a hacker OS that's not for end users. Sounds kinda rigged,
doesn't it?

There is a missing operating system out there. It is the OS Microsoft should
have written by now. Plan 9 isn't it. They're still about centralization.
MacOS-X isn't it. Utterly proprietary. That missing operating system is the
big hole in US cybersecurity. The world needs an end-user OS the NSA can
freely comment on the sources of.  Another free unix isn't compelling
enough. It needs to be something new.

As such, it is an opportunity for the US government to actually lead toward
something positive; An OS written with assistance from the NSA perhaps, but
designed by someone with an independent streak of a Forth guy.  An operating
system built from scratch for the best combination of speed,
maintainability, mutability, and security for individual users' machines
would have hardware process switching, but wouldn't require it of the owner
of a leaf-node machine. COTSU, the Church Of The Sub-Unix, is half-way
between Amigados and unix in terms of process control weight, using Block
Address Translation rather than full-blown VM, and the PM should be largely
optional, or situational. PM is protected memory, translated addresses of
guest processes, but not VM to the extent of virtualizing core out to store.
RAM must really exist. The OOM-killer is login; no more RAM, no more logins.
A process is a login. The only thing that forks or execves is login. A login
is potentially a Tripos/Cintpos/Amigados, or a Forth. Typical /bin utils
like grep, wc and so on should run as threads, and/or Forth equivalents,
which traditionally don't even require a filesystem. cotsu is a microkernel
in a Forth-like way, providing blocks, not files, to processes. cotsu owner
is approximately unix root, but owner can run Forth interpreters, graphics
apps and such in kernelspace if she wants to. Or in something more akin to
root, by logging in as guest-owner. And by the way, I set out to design an
OS, and came up with a micro-kernel, not vice-versa. The initial cotsu shell
is a one-stack Forth, FIF, Forth In Flatland, which see my Oct 4 post to
comp.lang.forth.

Crackability lives in bad ideas. There are a number of bad ideas fundamental
to open source unix. Typed data. SMP. Swap. brk(). 0-terminated strings.
everything-is-a-file. asm(""). brk is a bad idea vis-a-vis security because
it rewards application bloat. SMP is just not for normal users,
security-wise, besides being a grand mirage, and it now infests Linux
systemically. It doesn't #ifdef away. And so on. I personally abhor these
things for modifiability reasons, but they coincide with security issues.
Simple is survivable. This I know.

Cotsu backs these ideas down to their most maintainable level.
everything-is-a-file isn't actually as bad an idea as e.g. SMP, but it
strains mightily at the margins. Everything in cotsu is a block array, a
pipe, or I guess a packet, for example. Net stuff is my weak suit. I've
never tried to run a server OS. 9p from Plan 9 bears a look, I suppose.

Cotsu isn't real. I have been formulating it for years, most recently
sketching it on a Chinese MIPS netbook running Linux, but I haven't seen any
evidence that there is any way for an end-user to modify the boot sequence
of this gizmo. The recovery sequence apparently runs from Linux.  Thus cotsu
is still just a big design drawing. In fact, it's just a big brainfart, but
I'm right about the national security issue, and what could ameliorate it.
Since the first draft of this letter I've figured out how I can probably
boot something besides Linux on this netbook, but I've got some things going
on on Capitol Hill, like salaried job offers from Congressmen, that could
prove very time-consuming.

The design sketch of cotsu is partially written in osim, which is an
assembler for a generic 32 bit register CPU, written in sh. osim stands for
"one stack in memory", the same machine target range as gcc. It looks mostly
like a 386, but I have it stubbed out for the MIPS. That is, it is a
portable macro-assembler with a backend fleshed out for the MIPS. The
toolchain of cotsu then, is some dozens of kilobytes of shell script. The
shell used is the shell used by Busybox, which I feel is a good excuse for
"least capable shell you'll ever see a prompt for with a blinking cursor",
and appears to be entirely upward compatible with Bash. The performance hit
of binary assembled osim versus hand-coded native assembler for a particular
commodity 32 bit CPU is probably less than 2:1. Ritchie said C cost UNIX(TM)
about a 60% performance hit, and it was a much bigger issue in that
situation, and the improved portability is what really made unix, and the
internet, perhaps.

The advent of a real public domain client OS of some modernity at its base
might even be a good thing for small business. Microsoft certainly isn't.
Linux, in a sense, spawned Google, but things could be better for software
vendors, I suspect. The NSA might not be the hub of all trust relationships,
alas, but I don't know that they steal software and rebrand it. Microsoft
stole "shasm". There were no Google hits for shasm when I wrote it, IIRC. In
other words, the NSA is more trustworty than Microsoft. Faint praise, but a
crucial difference if you want to develop software, possibly for money, and
don't want to write an OS.

selinux is nice enough, I guess, but I don't see it becoming the prefered
system for leaf nodes, to which it is basically irelevant. If the NSA would
like to produce an alternative to MSDoS.GUI, and do the world a real favor,
the accountability to the public of a tiny and utterly transparent toolchain
would be a big plus, I'm sure. osim is a big wad of the most psuedo of all
psuedocode. In porting shasm from Bash to the busybox sh, much of it remains
broken, currently, but I have written bootable demos for the 386 in shasm
shell-assembly, in e.g. Forreal.tgz at my old cLIeNUX ftp site in Germany. I
think that's still up, but public library MSDOS.GUI machines are afraid of
ftp. (Yes, it's still there. ) That is, the 386 version DID work in shasm,
and the MIPS is trivial to write an assembler for by comparison. Given a
shell fn aq that appends a 'binary' quad to a file, this is MIPS ADD in sh
(reduced to using 2 registers for generic-ness) ...

add		() { #   r $1 + r $2 --> r $2
	aq	$(($1<<21|$2<<16|$2<<11|32))
}

A useable cotsu would need a filesystem, I suppose, to run a unix-style
shell that could build cotsu. I suggest the included MUFFS filesystem design
for leafnodes with arbitrarily large storage. Note the count-prefixed
strings in the dirents. And/or, a Forth-like shell that could assemble cotsu
from Forth blocks. The Forth is of course the easier bootstrap.
Promoteability would probably require a visual editor (see blackspace/bs),
an ed, and a web browser. Also of note to the curious developer with or
without NSA-like resources, you don't need so many device drivers to be
viable these days. Linux's vast trove of device drivers is largely a digital
necropolis. It makes a nice necklace.tgz for a pudgy stuffed penguin, I
guess.


COTSU IS
  a kernel that provides a blocks interface to store, ala Forth, written in
macro-assembler for a generic 32-bit CPU, similar to the BCPL intermediate
languages like sial, which provides protected memory and full
process-switching for guest processes, which map 1:1 with logins, but does
not provide virtualization of core out to store, but may run kernel
monitors, shells or Forths in kernelspace. cotsu also provides direct local
screen video control for owner use in kernelspace. Thus the kernel is a
Forth/Amigados cross. Guest processes will be like the Amiga CLI, or
Cintpos, in that utils will be tasks, not processes. Guest processes will be
preemptively multi-processed. I might put my notes and a bunch of pseudocode
up at presidentbyamendment.com, or not. This paragraph is a sufficient
outline. There it is. The missing operating system. This paragraph is the
part the NSA needed me for. You're welcome. Go. Do.

If you've seen one Forth, you've seen one Forth, as they say. A Forth is a
Linux where System.map is interpreter words. A true multi-user Forth OS in
the public domain would presumably immediately explode into dizzying
heterogeneity. That's a good thing for survivability of an entire internet.

I could go on and on, but this public library MSDOS.GUI box has gremlins in
it, and they seem to be getting agitated. Dear NSA; Please consider the
design of cotsu, Church Of The Sub-Unix, as a respectful project suggestion
from a fellow American, as public domain, and as a threat assessment and a
heads-up from a self-styled US Presidential candidate who writes assemblers
in unix shell script and writes Forth daemons for Linux, and is busy writing
constitutions, public transportation systems, mideast withdrawal plans
(partially successfully implemented in Iraq, BTW, see
presidentbyamendment.com/issues/platform.html), and monetary policies that
aren't broken by design. I don't have the time or a suitable devel machine,
the cloud is coming, it has an H1B, a face like Steve Ballmer, and a voice
like Bill Gates.

Who paid $260-- a share for the Redhat IPO? And why does Redhat smell so
much like Microsoft? And why did they all, not just Redhat, roll over when
Microsoft hit them with a poseur tax? Did they all follow Redhat's lead on
that one? Torvalds is still on the Paul Allen payroll, non? Does anyone in
the NSA have any sense of a security problem?

OK EVERYBODY, and all you posixers too, AND THE NSA! SING ALONG WITH BALLMER!

OH CLOUD  OH OH CLOUD....

The future lies beneath the present.

Rick Hohensee
September 20 2010
DC
presidentbyamendment.com
www.youtube.com/presidentbyamendment

libsys.a	xart	cLIeNUX		H3sm	H3rL	shasm	DSFH	validvote
cotsu design		cycluphonics		LAAETTR

sa/osim glossary, generic commodity CPU assembly language

NOT		()	{ #  unary NOT register $1 in situ
OR		()	{ #  r $1 OR  r $2 -> r $2
XOR		()	{ #  r $1 XOR r $2
AND		()	{ #  r $1 AND r $2 -> r $2
ANDI		()	{ #  r $1 AND imm $2 -> r $3
ORI		()	{ #  r $1 OR imm $2 -> r $3
XORI		()	{ #  r $1 XOR imm $2 -> r $3
move		()	{ #  move/clobber r $1 to r $2
loadi		()	{ #  imm $1 --> r $2
fetch		()	{ #  read memory at [r $1] into r $2
store		()	{ #  write r $1 to [r AR]
fetcho		()	{ #  read memory at [r $1 plus imm o/s $2] ->r $3
fetchp		()	{ #  read memory at [r $1] into r $2, 4+r$1->$1
storo		()	{ #  write r $1 to mem at [r $2 + imm o/s $3]
storeb		()	{ #  store byte in $1 to mem at [r $2]
storep		()	{ #  write r $1 to [r $2], add 4 to r $2
push		() 	{ #  regs $@ to stack with SP+++
pull		()	{ #  regs $@ from stack with ---SP
add		()	{ #  r $1 + r $2 -> r $2
addi		()	{ #  imm $1 + r $2 -> r $3
negate		()	{ #  2s compl. negate; decr, then NOT. or NOT, then incr :o)
divmod		()	{ #  r $1 /% r $2  , quo -> r $1, mod -> r $3
minus		()	{ #  r $2 - r $1 -> r $2,  result--> right
mul		()	{ #  r $1 * r $2 -> lo in r $1, hi in r $2
scale		()	{ #  r $1 * r $2 -> double tmp, dtmp>> by imm $3 -> r $1
upsh		()	{ #  r $1 << by r $2 	-> 	r $1
upshi		()	{ #  r $1 << by imm $2 	-> 	r $1
downshi  	()	{ #  >> r $1 by imm $2 -> r $1
downsh  	()	{ #  >> r $1 by r $2 -> r $1
b		() 	{ #  short branch relative	unconditional
bz		()	{ #  short branch relative	if r $1 = zero
bnz		()	{ #  short branch relative 	if r $1 non-zero
bn		()	{ #  short branch relative	if r $1 negative
bp		()	{ #  short branch relative	if r $1 positive
j		()	{ #  long unconditional branch to literal address
jr		()	{ #  jump to address in r $1, no stack action
js		()	{ #  jsr: push IP to SP, 4+SP, jump to (label) arg $1
jx		()	{ #  j ->  [ imm baseaddr $1 + reg C<<2 ], bangs A
rfs		()	{ #  rts: jump SP, SP-4
enter		()	{ #  push IP and frame to SP, jump to labeled address
leave		()	{ #  jump SP, drop SP frame
copies		() 	{ #  plural mem move @SI++ to @DI++, Count-1, cell ply
fill		() 	{ #  kinda like the 386. $1, $DI, Count-1, cell ply
sum		()	{ #  add. checksum, quad ply, sum in r $1, buf in r $SI
xsum		()	{ #  XOR checksum, quad ply, sum in r $1, buf in SI
halt		()	{ #  cool CPU until irq
syscall		()	{ #  no lit. numb. arg. Args in A, B, C...
irqson		()	{ #  allow interrupts
irqsoff		()	{ #  disallow interrupts
irqret		()	{ #  return from irq



sa/helpers

  meg=0x100000                   # meg is max and min's oldest daughter



numbering	() { # C enum, but not strictly constants and no commas
if test "$1" = "h" ; then  echo -e  "


C enum, but not enforced constant, and no commas

Assign sequential integer values to a series of names in assembly (shell)
state. This would have been C enum or BCPL MANIFEST if I had bothered with
the Bash \"constant\" type-declaration schtuff. You want em constant, don't
change em. Interactively, have a go with...

	numbering zero one 16 sixteen seventeen eighteen
	echo \$zero \$one  \$eighteen

As in C, the sequence can be coerced to a new starting count, which "16"
does in the above, except that you can't reset the sequence to 0 because of
a number/string parsing hack. Just use another numbering for another 0. Or a
shell variable declaration :o) \"numbering\" strikes me as kinda dumb, but
it was easy to implement, and C has it. The Plan 9 from Bell Labs code has a
lot of use of enum, I guess because it's a lot less typing than using cpp
for lots of constants. It also supposedly gives the compiler more to munch
on, but that doesn't pertain to sa. And lo and behold, I use it for fake
binary numbers.

CAUTION: reusing a name like  bla  in a numbering will reset the numbering
to the value recently numbered, so use a unique name for every placeholder
where you want the numbering to continue. For example,

  numbering       hey way say skip flay skip day        # will set those to
                  0   1   2    3   4    3    4

    See? The second skip is already 3. And fixing it isn't worth it.


  ">/dev/null

else     
#######################################################################
	let ecount=0
	for arg in $*							;do
	     if test $(($arg)) -ne 0				;then
	         let ecount=$(($arg))
	     else
	         let $arg=$ecount		# assignment to $tring. :o)
	         let ecount=$ecount+1
	     fi
	done
fi
}


shake 		() { #	do a plural modify-time comparison like make
if test "$1" = "h" ; then  echo -e  "

shake, SHell mAKE,

   does the fundamental modification-time comparison  make  is based on,
	without being a whole new kfreaking ersatx glanguage community.
   Sends some clucking to stderr.
   written with Bash, should work with ash.
				# presidentbyamendment.com   April 2009

<for each shake target in your shakefile, you could e.g....>

if shake  target		source1 source2 source3
then 	do_whatever
	whatever
	whatEver
fi

Thus, if any of the source files is newer than target, do the then  
part, which presumably
rebuilds target based on the source files. That would look like...

if shake  proggy	      module     part  proggy.sa
then	passes module.sa
	passes part.sa
	passes proggy.sa
	ls -l proggy
fi

Thus small components of a big project should be first in the shakefile, so
that small changes propagate up-dependancy properly, which is typically the
case with make anyway, non?

When did the shell get -nt (newer than)? That's when  make  became extraneous.

"|less

else    ######################################################################
	target=$1
	if ! test -e $target
	then
		echo " no "$target "   Try    shake h "
		return 0
	fi
	shift				# shift out target from the list
	for sou 			#  "in $@" is assumed. And shifted. :o)
	do
		if test $sou -nt $target
		then
			echo $sou " is newer"
			return 0
		fi
	done
	echo $target" OK already."
	return 1
fi
} >&2


rpn	 	() { #  CQD RPN calculator

if test  $# -eq 0
then
	echo "
	CQD RPN integer calculator for leaving calcs of weird bitmasks and
	such in your sa code like Chuck does in colorforth. The \"stack\" is only
	3 deep, so you can't do 3 4 5 6 + +  +; 3 goes in the bitbucket when  
6 happens.
	+, -, u(pshift), d(ownshift), AND, OR, XOR and NOT, Upper or lower case,
	e.g. AND can be a, A, and, AND, etc. Output is decimal.

	Hex and octal input are sh usual, 0xf1 and 041 e.g.

	rpn 0xdd<ret>      echoes 221.

	m(ultiply) is multiply, / is divide, % is remainder.

	echoes TOS when done, so you can foo=\`rpn 3 12 u 1 o \`

" | less
else	##__________________________________________________________

tos=0 sos=0 nos=0
for i in $*
do
	case $i in
	        +)	let tos=$tos+$sos
			let sos=$nos
				;;
	        -)	let tos=$sos-$tos
			let sos=$nos
				;;
		U*|u*)	let tos=$((sos<<$tos))		# upshift
			let sos=$nos
				;;
		D*|d*)	let tos=$((sos>>$tos))		# downshift
			let sos=$nos
				;;
		X*|x*)	let tos=$tos^$sos		# xor
			let sos=$nos
				;;
		A*|a*)	let tos=$((tos&$sos))		# and
			let sos=$nos
				;;
		N*|n*)	let tos=~$tos			# bitwise NOT, need negative?
				;;			#     input a negative

		/)	let tos=$((sos/tos))
			let sos=$nos			;;
		%)	let tos=$((sos%tos))
			let sos=$nos			;;

		m*)	let tos=$((sos*tos))
			let sos=$nos			;;

		O*|o*)	let tos=$((tos|$sos))		# or
			let sos=$nos
				;;
		*)
			let nos=$sos
			let sos=$tos
			let tos=$i
				;;
	esac
done
  echo $tos
fi
}

Wed Sep 22 12:21:22 UTC 2010

Wed Oct  6 13:27:15 UTC 2010

And see my Oct 4 post to comp.lang.forth  -->


