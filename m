Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab1DTMT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 08:19:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab1DTMTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 08:19:53 -0400
Date: Wed, 20 Apr 2011 14:19:51 +0200
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: [ANNOUNCE] util-linux v2.19.1-rc1
Message-ID: <20110420121951.GB29492@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The first util-linux-ng 2.19.1 release candidate is available at

   ftp://ftp.kernel.org/pub/linux/utils/util-linux/v2.19/

Feedback and bug reports, as always, are welcomed.

	Karel


util-linux 2.19.1 Release Notes
===============================

Changes since v2.19
-------------------

 For more details see ChangeLog files at:
 ftp://ftp.kernel.org/pub/linux/utils/util-linux/v2.19/

blkid:
   - don't ignore -i  [Karel Zak]
   - fix double free [coverity scan]  [Karel Zak]
   - small fix for safe_print()  [Sergey Gusarov]
build-sys:
   - don't build lsblk on Linux without openat()  [Karel Zak]
chsh:
   - fix gcc link() warn_unused_result warning  [Karel Zak]
   - fix small memory leak  [Karel Zak]
ddate:
   - remove non-ascii chars from ddate  [Karel Zak]
docs:
   - update AUTHORS file  [Karel Zak]
fdisk:
   - check index before access to array [coverity scan]  [Karel Zak]
   - more robust whole-disk detection  [Karel Zak]
findmnt:
   - check mnt_tab_next_fs() return code [coverity scan]  [Karel Zak]
fsck:
   - fix -C parsing  [Karel Zak]
include:
   - [at.h]  include c.h for PATH_MAX  [Karel Zak]
   - [c.h]  typeof to __typeof__ fix  [Sami Kerola]
   - [c.h] add definition wrappers for old libc versions  [Davidlohr Bueso]
lib:
   - [strutils.c] more robust strtol checks  [Karel Zak]
   - [strutils] avoid integer overflow on large values  [Dave Reisner]
   - [tt.c] dereferencing data before a null check [coverity scan]  [Karel Zak]
libblkid:
   - add PART_ENTRY_* to docs  [Karel Zak]
   - fix EFI GPT uuid byte order  [Karel Zak]
   - fix gcc warnings  [Karel Zak]
   - fix typo in *_to_cpu() usage in raid detection [coverity scan]  [Karel Zak]
   - remove test for non-zero head count in FAT superblock probe.  [Nick Holloway]
   - try to detect if PT is newer than LVM  [Karel Zak]
   - use blkid_probe_get_buffer() more carefully  [Karel Zak]
libmount:
   - add fallbacks for old systems without umount2() syscall  [Karel Zak]
   - avoid redundant declaration of mnt_context_do_umount  [Jan Engelhardt]
   - block signals when update utab  [Karel Zak]
   - block signals when writing to mtab  [Karel Zak]
   - cleanup *_do_[u]mount() return codes and docs  [Karel Zak]
   - create a default lock for mtab update  [Karel Zak]
   - fix memory leak in cache  [Karel Zak]
   - fix parsing of mountinfo from 2.6.39  [Karel Zak]
   - keep code more readable for analyzers [coverity scan]  [Karel Zak]
   - more robust mtab and utab update (CVE-2011-1676, CVE-2011-1677)  [Karel Zak]
   - remove unused variable from test  [Karel Zak]
   - replace mkostmps() with more portable mkstemp()  [Karel Zak]
   - small lock code cleanup  [Karel Zak]
   - support /run/mount rather than /dev/.mount  [Karel Zak]
libuuid:
   - do not use invalid file descriptor  [Petr Uzel]
   - fix test in get_clock()  [Petr Uzel]
   - manpage spelling fixes  [Petr Uzel]
logger:
   - fix variable type compiler warning  [Sami Kerola]
login:
   - does not ignore setgid() return code for non-roots  [Karel Zak]
   - fix checktty test to compile with old glibc  [Karel Zak]
lsblk:
   - bitwise or TT_FL_ASCII with tt_flags instead of setting  [Dave Reisner]
   - fix readlink() usage  [Karel Zak]
   - fix strtoul() usage [coverity scan]  [Karel Zak]
   - use ssize_t for readlink() return code  [Karel Zak]
lscpu:
   - detect sun4{u,v} in /proc/cpuinfo for sparc64  [Karel Zak]
   - fix op-mode for /{sys,proc} dumps  [Karel Zak]
   - fix threads-per-core calculation  [Karel Zak]
mount:
   - add note about blank lines to fstab.5  [Karel Zak]
   - remove unused variable  [Karel Zak]
   - update mtab on "-f" and compiled with libmount  [Karel Zak]
   - use fflush() and temporary file for mtab updates (CVE-2011-1089)  [Karel Zak]
   - use lock from mnt_update_table()  [Karel Zak]
partx, lsblk:
   - fix gettext calls  [Karel Zak]
po:
   - merge changes  [Karel Zak]
   - update da.po (from translationproject.org)  [Joe Hansen]
   - update fr.po (from translationproject.org)  [David Prévot]
readprofile:
   - don't stop parsing at __init_end  [Po-Yu Chuang]
rev:
   - memory leak fix  [Sami Kerola]
script:
   - fix compiler warnings  [Sami Kerola]
scriptreplay:
   - bug in argument check  [Sami Kerola]
setterm:
   - segfault with long dump file name  [Sami Kerola]
tailf:
   - fix open() return value check [coverity scan]  [Karel Zak]
   - support --lines 0  [Karel Zak]
tests:
   - add test for RLIMIT_FSIZE issue  [Karel Zak]
   - add tests for [u]mount regular file  [Karel Zak]
   - don't run mount/regfile test on old kernel  [Karel Zak]
   - update GPT test  [Karel Zak]
   - use libmount tab update tests for UID=0 only  [Karel Zak]
umount:
   - allow unmounting loopdev specified by associated file  [Petr Uzel]
   - block signals when umounting and updating mtab (CVE-2011-1676, CVE-2011-1677)  [Karel Zak]
   - segfaults with inconsistent entry in /etc/fstab  [Karel Zak]
   - support non-canonical devnames in mtab  [Karel Zak]
   - use UMOUNT_NOFOLLOW for non-root users  [Karel Zak]
uuidd:
   - fix manpage  libuuid(3) does not exist  [Petr Uzel]

