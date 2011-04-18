Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab1DRXIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 19:08:14 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:51775 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750994Ab1DRXIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 19:08:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WaTpjBhJ5G0a5r0tthbDdz8YcjVHPI8/SqOdG/HDty9A9BfobZgn8lwB+rPuq/vA/TxTkkqlafwvwafP7G7Z+k3holxPNLkKaMyUg+JMSjgB3EZufF6y/wkDVNceHBhY;
Date: Mon, 18 Apr 2011 16:08:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Michael Prokop <mika@grml.org>
Subject: [PATCH] Documentation/dontdiff: large update
Message-Id: <20110418160809.f10c0b62.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Update to Documentation/dontdiff, based on many updates to
various .gitignore patches over the last 2 years.

Initially begun by Michael Prokop <mika@grml.org>, with lots of
changes by Randy Dunlap.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michael Prokop <mika@grml.org>
---
 Documentation/dontdiff |   66 ++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 18 deletions(-)

--- lnx-2639-r3g8-dontdiff.orig/Documentation/dontdiff
+++ lnx-2639-r3g8-dontdiff/Documentation/dontdiff
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
@@ -112,18 +132,14 @@ generated
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
-int16.c
-int1.c
-int2.c
-int32.c
-int4.c
-int8.c
+int*.c
 kallsyms
 kconfig
 keywords.c
@@ -133,15 +149,20 @@ kxgettext
 lkc_defs.h
 lex.c
 lex.*.c
+lib1funcs.S
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
@@ -150,23 +171,29 @@ mkbugboot
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
@@ -177,10 +204,9 @@ r200_reg_safe.h
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
@@ -194,6 +220,7 @@ split-include
 syscalltab.h
 tables.c
 tags
+test_get_len
 tftpboot.img
 timeconst.h
 times.h*
@@ -210,10 +237,13 @@ vdso32.so.dbg
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
