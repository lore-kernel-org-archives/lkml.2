Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab1EWTCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:02:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39056 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270Ab1EWTCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:02:30 -0400
Date: Mon, 23 May 2011 11:55:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, Michael Prokop <mika@grml.org>,
        Joe Perches <joe@perches.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 1/5] Documentation: update dontdiff file
Message-Id: <20110523115542.dcf23f5d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DDAAF16.007E:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

v2, updated based on comments from Joe and Paul.

Update to Documentation/dontdiff, based on many updates to
various .gitignore patches over the last 2 years.

Initially begun by Michael Prokop <mika@grml.org>, with lots of
changes by Randy Dunlap.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michael Prokop <mika@grml.org>
Cc: Joe Perches <joe@perches.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 Documentation/dontdiff |   58 ++++++++++++++++++++++++++++++---------
 1 file changed, 46 insertions(+), 12 deletions(-)

--- linux-2.6.39-git6.orig/Documentation/dontdiff
+++ linux-2.6.39-git6/Documentation/dontdiff
@@ -1,6 +1,8 @@
 *.a
 *.aux
 *.bin
+*.bz2
+*.cis
 *.cpio
 *.csp
 *.dsp
@@ -8,6 +10,8 @@
 *.elf
 *.eps
 *.fw
+*.gcno
+*.gcov
 *.gen.S
 *.gif
 *.grep
@@ -19,14 +23,20 @@
 *.ko
 *.log
 *.lst
+*.lzma
+*.lzo
+*.mo
 *.moc
 *.mod.c
 *.o
 *.o.*
+*.order
 *.orig
 *.out
+*.patch
 *.pdf
 *.png
+*.pot
 *.ps
 *.rej
 *.s
@@ -39,16 +49,22 @@
 *.tex
 *.ver
 *.xml
+*.xz
 *_MODULES
 *_vga16.c
 *~
+\#*#
 *.9
-*.9.gz
 .*
+.*.d
 .mm
 53c700_d.h
 CVS
 ChangeSet
+GPATH
+GRTAGS
+GSYMS
+GTAGS
 Image
 Kerntypes
 Module.markers
@@ -57,15 +73,14 @@ PENDING
 SCCS
 System.map*
 TAGS
+aconf
+af_names.h
 aic7*reg.h*
 aic7*reg_print.c*
 aic7*seq.h*
 aicasm
 aicdb.h*
-altivec1.c
-altivec2.c
-altivec4.c
-altivec8.c
+altivec*.c
 asm-offsets.h
 asm_offsets.h
 autoconf.h*
@@ -80,6 +95,7 @@ btfixupprep
 build
 bvmlinux
 bzImage*
+capability_names.h
 capflags.c
 classlist.h*
 comp*.log
@@ -88,7 +104,8 @@ conf
 config
 config-*
 config_data.h*
-config_data.gz*
+config.mak
+config.mak.autogen
 conmakehash
 consolemap_deftbl.c*
 cpustr.h
@@ -96,7 +113,9 @@ crc32table.h*
 cscope.*
 defkeymap.c
 devlist.h*
+dnotify_test
 docproc
+dslm
 elf2ecoff
 elfconfig.h*
 evergreen_reg_safe.h
@@ -105,6 +124,7 @@ flask.h
 fore200e_mkfirm
 fore200e_pca_fw.c*
 gconf
+gconf.glade.h
 gen-devlist
 gen_crc32table
 gen_init_cpio
@@ -112,11 +132,12 @@ generated
 genheaders
 genksyms
 *_gray256.c
+hpet_example
+hugepage-mmap
+hugepage-shm
 ihex2fw
 ikconfig.h*
 inat-tables.c
-initramfs_data.cpio
-initramfs_data.cpio.gz
 initramfs_list
 int16.c
 int1.c
@@ -133,15 +154,19 @@ kxgettext
 lkc_defs.h
 lex.c
 lex.*.c
+linux
 logo_*.c
 logo_*_clut224.c
 logo_*_mono.c
 lxdialog
+mach
 mach-types
 mach-types.h
 machtypes.h
 map
+map_hugetlb
 maui_boot.h
+media
 mconf
 miboot*
 mk_elfconfig
@@ -150,23 +175,29 @@ mkbugboot
 mkcpustr
 mkdep
 mkprep
+mkregtable
 mktables
 mktree
 modpost
 modules.builtin
 modules.order
 modversions.h*
+nconf
 ncscope.*
 offset.h
 offsets.h
 oui.c*
+page-types
 parse.c
 parse.h
 patches*
 pca200e.bin
 pca200e_ecd.bin2
-piggy.gz
+perf.data
+perf.data.old
+perf-archive
 piggyback
+piggy.gzip
 piggy.S
 pnmtologo
 ppc_defs.h*
@@ -177,10 +208,9 @@ r200_reg_safe.h
 r300_reg_safe.h
 r420_reg_safe.h
 r600_reg_safe.h
-raid6altivec*.c
-raid6int*.c
-raid6tables.c
+recordmcount
 relocs
+rlim_names.h
 rn50_reg_safe.h
 rs600_reg_safe.h
 rv515_reg_safe.h
@@ -194,6 +224,7 @@ split-include
 syscalltab.h
 tables.c
 tags
+test_get_len
 tftpboot.img
 timeconst.h
 times.h*
@@ -210,10 +241,13 @@ vdso32.so.dbg
 vdso64.lds
 vdso64.so.dbg
 version.h*
+vmImage
 vmlinux
 vmlinux-*
 vmlinux.aout
+vmlinux.bin.all
 vmlinux.lds
+vmlinuz
 voffset.h
 vsyscall.lds
 vsyscall_32.lds
