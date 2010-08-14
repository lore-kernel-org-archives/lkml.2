Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab0HNUxZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 16:53:25 -0400
Received: from 70.mail-out.ovh.net ([91.121.185.63]:45949 "HELO
	70.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755274Ab0HNUxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 16:53:24 -0400
Message-ID: <4C67023D.6050603@example.com>
Date: Sat, 14 Aug 2010 22:53:17 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: ioctl definition - has it changed recently?
Content-Type: multipart/mixed;
 boundary="------------080300060609060708090802"
X-Ovh-Tracer-Id: 162129588668952856
X-Ovh-Remote: 83.24.108.121 (doa121.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080300060609060708090802
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

I build new kernels when they become available. Now I have a problem. 
After I install new kernel I have to run NVidia setup script. Starting 
from git15 it fails, see attached file. The error line is here:

    /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.c: At top level:
    /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.c:426: error: 
unknown field ‘ioctl’ specified in initializer
    /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.c:426: warning: 
initialization from incompatible pointer type

In git14 everything was OK, but now it is not, also with the Git synced 
kernel. Has something changed from git14 times? I hope that it changed 
in Linux because it will be fixed earlier than NVidia source.

My graphic card is 01:00.0 VGA compatible controller: nVidia Corporation 
G96 [GeForce 9400 GT] (rev a1)

Regards,

Piotr Hosowicz

-- 
Muller wiedział, że Rosjanie, zamieszawszy cukier, zostawiają łyżkę w
szklance z herbatą. Chcąc sprawdzić Stirlitza, zaprosił go do siebie
na herbatę. Stirlitz wsypał cukier do szklanki, zamieszał go, wyjął
łyżeczkę, położył ją na spodeczku, po czym pokazał Mullerowi język.
NP: Peter Green Splinter Group - There's A River
NB: 2.6.35-git14

--------------080300060609060708090802
Content-Type: text/x-log;
 name="nvidia-installer.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="nvidia-installer.log"

nvidia-installer log file '/var/log/nvidia-installer.log'
creation time: Sat Aug 14 18:57:00 2010
installer version: 256.35

option status:
  license pre-accepted    : false
  update                  : false
  force update            : false
  expert                  : true
  uninstall               : false
  driver info             : false
  precompiled interfaces  : true
  no ncurses color        : false
  query latest version    : false
  OpenGL header files     : true
  no questions            : false
  silent                  : false
  no recursion            : false
  no backup               : false
  kernel module only      : false
  sanity                  : false
  add this kernel         : false
  no runlevel check       : false
  no network              : false
  no ABI note             : false
  no RPMs                 : false
  no kernel module        : false
  force SELinux           : default
  no X server check       : false
  no cc version check     : false
  force tls               : (not specified)
  force compat32 tls      : (not specified)
  X install prefix        : (not specified)
  X library install path  : (not specified)
  X module install path   : (not specified)
  OpenGL install prefix   : (not specified)
  OpenGL install libdir   : (not specified)
  compat32 install chroot : (not specified)
  compat32 install prefix : (not specified)
  compat32 install libdir : (not specified)
  utility install prefix  : (not specified)
  utility install libdir  : (not specified)
  doc install prefix      : (not specified)
  kernel name             : (not specified)
  kernel include path     : (not specified)
  kernel source path      : /usr/src/linux-2.6.35-git15
  kernel output path      : (not specified)
  kernel install path     : (not specified)
  proc mount point        : /proc
  ui                      : (not specified)
  tmpdir                  : /tmp
  ftp mirror              : ftp://download.nvidia.com
  RPM file list           : (not specified)

chdir("./")
Using: nvidia-installer ncurses user interface
-> Searching for system utilities:
-> found `ldconfig` : `/sbin/ldconfig`
-> found `ldd` : `/usr/bin/ldd`
-> found `ld` : `/usr/bin/ld`
-> found `objcopy` : `/usr/bin/objcopy`
-> found `grep` : `/bin/grep`
-> found `dmesg` : `/bin/dmesg`
-> found `tail` : `/usr/bin/tail`
-> found `cut` : `/usr/bin/cut`
-> found `tr` : `/usr/bin/tr`
-> found `sed` : `/bin/sed`
-> found `chcon` : `/usr/bin/chcon`
-> found `pkg-config` : `/usr/bin/pkg-config`
-> found `X` : `/usr/bin/X`
-> Searching for module utilities:
-> found `insmod` : `/sbin/insmod`
-> found `modprobe` : `/sbin/modprobe`
-> found `rmmod` : `/sbin/rmmod`
-> found `lsmod` : `/sbin/lsmod`
-> found `depmod` : `/sbin/depmod`
-> License accepted.
-> Installing NVIDIA driver version 256.35.
-> There appears to already be a driver installed on your system (version: 256.
   35).  As part of installing this driver (version: 256.35), the existing driv
   er will be uninstalled.  Are you sure you want to continue? ('no' will abort
   installation) (Answer: Yes)
-> No distribution pre-install script found.
-> Kernel module installation path (Answer:
   '/lib/modules/2.6.35-git15/kernel/drivers/video')
-> Kernel module installation path: /lib/modules/2.6.35-git15/kernel/drivers/vi
   deo
-> No precompiled kernel interface was found to match your kernel; this means
   that the installer will need to compile a new kernel interface.
-> Checking development tools:
-> found `cc` : `/usr/bin/cc`
-> found `make` : `/usr/bin/make`
-> Performing CC sanity check with CC="cc".
-> Performing CC version check with CC="cc".
-> Using the kernel source path '/usr/src/linux-2.6.35-git15' as specified by
   the '--kernel-source-path' commandline option.
-> Kernel source path (Answer: '/usr/src/linux-2.6.35-git15')
-> Kernel source path: '/usr/src/linux-2.6.35-git15'
-> Kernel output path: '/usr/src/linux-2.6.35-git15'
-> Performing rivafb check.
-> Performing nvidiafb check.
-> Performing Xen check.
-> Cleaning kernel module build directory.
   executing: 'cd ./kernel; make clean'...
-> Building kernel module:
   executing: 'cd ./kernel; make module SYSSRC=/usr/src/linux-2.6.35-git15 SYSO
   UT=/usr/src/linux-2.6.35-git15'...
   NVIDIA: calling KBUILD...
   test -e include/generated/autoconf.h -a -e include/config/auto.conf || (		\
   	echo;								\
   	echo "  ERROR: Kernel configuration is invalid.";		\
   	echo "         include/generated/autoconf.h or include/config/auto.conf are
   missing.";\
   	echo "         Run 'make oldconfig && make prepare' on kernel src to fix it
   .";	\
   	echo;								\
   	/bin/false)
   mkdir -p /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/.tmp_versions ; r
   m -f /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/.tmp_versions/*
   make -f scripts/Makefile.build obj=/tmp/selfgz6622/NVIDIA-Linux-x86_64-256.3
   5/kernel
     cc -Wp,-MD,/tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/.nv.o.d  -nos
   tdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.5/include -I/usr/src/linux-
   2.6.35-git15/arch/x86/include -Iinclude  -include include/generated/autoconf
   .h -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict
   -aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-secu
   rity -fno-delete-null-pointer-checks -O
   s -m64 -march=core2 -mno-red-zone -mcmodel=kernel -funit-at-a-time -maccumul
   ate-outgoing-args -fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL
   _FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare -fno-asynchronou
   s-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -Wframe-larger-than=2
   048 -fno-omit-frame-pointer -fno-optimize-sibling-calls -g -Wdeclaration-aft
   er-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -I/tmp/
   selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel -Wall -MD -Wsign-compare -Wno-c
   ast-qual -Wno-error -D__KERNEL__ -DMODULE -DNVRM -DNV_VERSION_STRING=\"256.3
   5\" -mcmodel=kernel -mno-red-zone -UDEBUG -U_DEBUG -DNDEBUG  -DMODULE  -D"KB
   UILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(nv)"  -D"KBUILD_MODNAME=KBUILD
   _STR(nvidia)" -D"DEBUG_HASH=29" -D"DEBUG_HASH2=36" -c -o /tmp/selfgz6622/NVI
   DIA-Linux-x86_64-256.35/kernel/.tmp_nv.o /tmp/selfgz6622/NVIDIA-Linux-x86_64
   -256.35/kernel/nv.c
   In file included from include/linux/kernel.h:17,
                    from include/linux/sched.h:54,
                    from include/linux/utsname.h:35,
                    from /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv-l
   inux.h:27,
                    from /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.c
   :13:
   include/linux/bitops.h: In function ‘hweight_long’:
   include/linux/bitops.h:49: warning: signed and unsigned type in conditional 
   expression
   In file included from /usr/src/linux-2.6.35-git15/arch/x86/include/asm/uacce
   ss.h:573,
                    from include/linux/poll.h:14,
                    from /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv-l
   inux.h:84,
                    from /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.c
   :13:
   /usr/src/linux-2.6.35-git15/arch/x86/include/asm/uaccess_64.h: In function �
   ��copy_from_user’:
   /usr/src/linux-2.6.35-git15/arch/x86/include/asm/uaccess_64.h:54: warning: c
   omparison between signed and unsigned integer expressions
   /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.c: At top level:
   /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.c:426: error: unknown f
   ield ‘ioctl’ specified in initializer
   /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.c:426: warning: initial
   ization from incompatible pointer type
   make[3]: *** [/tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.o] Błąd
   1
   make[2]: *** [_module_/tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel] Bł
   ąd 2
   NVIDIA: left KBUILD.
   nvidia.ko failed to build!
   make[1]: *** [module] Błąd 1
   make: *** [module] Błąd 2
-> Error.
ERROR: Unable to build the NVIDIA kernel module.
ERROR: Installation has failed.  Please see the file
       '/var/log/nvidia-installer.log' for details.  You may find suggestions
       on fixing installation problems in the README available on the Linux
       driver download page at www.nvidia.com.
-> No distribution failed-install script found.

--------------080300060609060708090802--
