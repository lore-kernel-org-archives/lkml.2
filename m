Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab1DTQOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:14:10 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:42678 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754761Ab1DTQOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:14:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=CBbIttM+GcSLaMXJz4rlsuf2JV9kT0eu3YX9fJd5z5HJlb4EnN+Hl6PfRNp7dRAdQGCTGlFUG9fMOMnmfOgO78Mr2wykb2/6nffKIj8U/uOCvU4JPTFivi6iGcq0/D3C;
Date: Wed, 20 Apr 2011 09:14:04 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Joe Perches <joe@perches.com>, Michael Prokop <mika@grml.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH v2] Documentation/dontdiff: large update
Message-Id: <20110420091404.f7e178ee.rdunlap@xenotime.net>
In-Reply-To: <20110418214637.88f5bd3d.rdunlap@xenotime.net>
References: <20110418160809.f10c0b62.rdunlap@xenotime.net>
	<1303176177.31723.58.camel@Joe-Laptop>
	<20110418214637.88f5bd3d.rdunlap@xenotime.net>
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

--- lnx-2639-r3g8-docum.orig/Documentation/dontdiff
+++ lnx-2639-r3g8-docum/Documentation/dontdiff
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
