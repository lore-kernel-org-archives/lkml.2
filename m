Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab2LMMIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 07:08:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab2LMMIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 07:08:21 -0500
Date: Thu, 13 Dec 2012 13:08:18 +0100
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: [ANNOUNCE] util-linux v2.22.2
Message-ID: <20121213120818.GA14601@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The util-linux release v2.22.2 is available at

  ftp://ftp.kernel.org/pub/linux/utils/util-linux/2.22

Feedback and bug reports, as always, are welcomed.

  Karel


util-linux 2.22.2 Release Notes
===============================

Changes since v2.22.1
---------------------

 For more details see ChangeLog files at:
 ftp://ftp.kernel.org/pub/linux/utils/util-linux/v2.22/

agetty:
   - fix autodetection for TERM  [Michal Schmidt]
blkid:
   - fix double free [coverity scan]  [Karel Zak]
   - fix man page mess  [Karel Zak]
chfn:
   - always use return rather than exit() in main  [Karel Zak]
   - clean up exit status  [Karel Zak]
chsh:
   - use return rather than exit in main, clean up man page  [Karel Zak]
docs:
   - remove dead link  [Sami Kerola]
   - update AUTHORS file  [Karel Zak]
fsck.cramfs:
   - compile with -DINCLUDE_FS_TESTS for make check  [Karel Zak]
lib/canonicalize:
   - add canonicalize_path_restricted() to canonicalize without suid permisssions  [Karel Zak]
lib/loopdev:
   - check for /sys  [Karel Zak]
   - improve debug messages  [Karel Zak]
   - make loopcxt_get_device() more robust  [Karel Zak]
libblkid:
   - (gpt) don't modify in memory buffers  [Karel Zak]
   - check mkdir(/run/blkid) return code [coverity scan]  [Karel Zak]
   - fix compiler warning [-Wstrict-aliasing]  [Karel Zak]
   - re-read PART{UUID,LABEL} for successfully verified cached devices  [Karel Zak]
   - remove obsolete tags from cache  [Karel Zak]
libmount:
   - correctly interpret '*' from /etc/filesystems  [Karel Zak]
   - don't reset NOSWAPMATCH context flag  [Karel Zak]
   - don't try to play with loopdevs if umount argument is really mountpoint  [Karel Zak]
   - don't use umount optimization for -l or -f  [Karel Zak]
   - fix support of comma-separated fs types lists  [Gleb Fotengauer-Malinovskiy]
   - fix typos  [Karel Zak]
   - make debug stuff more robust  [Karel Zak]
   - make mkstemp() more robust [coverity scan]  [Karel Zak]
   - more robust tab filter usage  [Karel Zak]
login:
   - check lastlog lseek return code [coverity scan]  [Karel Zak]
   - fix compiler warning [-Wunused-result]  [Karel Zak]
lsblk:
   - fix copy & past bug  [Karel Zak]
lscpu:
   - Fix issue found on CPU hot-remove  [Toshi Kani]
   - make read_topology() more robust to avoid SIGFPE  [Karel Zak]
misc:
   - make readlink() usage more robust  [Karel Zak]
mount:
   - add -c abbreviation for --no-canonicalize to man page  [Bill Pemberton]
   - add long options for -L and -U to man page  [Bill Pemberton]
   - sanitize paths from non-root users  [Karel Zak]
po:
   - merge changes  [Karel Zak]
   - update cs.po (from translationproject.org)  [Petr Pisar]
   - update da.po (from translationproject.org)  [Joe Hansen]
script:
   - do not try to close stderr twice  [Sami Kerola]
swapon:
   - fix memmory leak [coverity scan]  [Karel Zak]
   - remove loop declaration [smatch scan]  [Sami Kerola]
tests:
   - remove lscpu /sys dumps without 'possible' CPU mask  [Karel Zak]
umount:
   - allways return MOUNT_EX_*  [Karel Zak]
   - sanitize paths from non-root users  [Karel Zak]
uuidgen:
   - fix --random  [Karel Zak]
wipefs:
   - Add --force option to force it to erase.  [Richard W.M. Jones]
   - use O_EXCL  [Karel Zak]
