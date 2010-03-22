Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab0CVKG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 06:06:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab0CVKG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 06:06:26 -0400
Date: Mon, 22 Mar 2010 11:06:24 +0100
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: [ANNOUNCE] util-linux-ng v2.17.2
Message-ID: <20100322100624.GF6118@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The bugfix release util-linux-ng 2.17.2 is available at

   ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.17/

Feedback and bug reports, as always, are welcomed.

	Karel


Util-linux-ng 2.17.2 Release Notes
==================================

Changes since v2.17.1
---------------------

 For more details see ChangeLog files at:
 ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.17/

docs:
   - fix small typo in v2.17.1-ReleaseNotes  [Karel Zak]
   - update AUTHORS file  [Karel Zak]
fdisk:
   - fix -b <sectorsize>  [Karel Zak]
ionice:
   - fix typo  [Pierre Hauweele]
lib:
   - add #ifndef around min() max() macros  [Karel Zak]
libblkid:
   - fix display of device size  [Karel Zak]
   - fix infinite loop when probe chain bails out early  [Colin Watson]
   - more robust minix probing  [Karel Zak]
   - remove "0x" prefix from DRBD UUID  [Karel Zak]
   - reset BLKID_TINY_DEV flag in blkid_probe_set_device  [Pascal Terjan]
   - support alignment_offset=-1  [Karel Zak]
lscpu:
   - fix cpuid opcode detection  [Henne Vogelsang]
mount:
   - more explicitly explain fstab usage in mount.8  [Karel Zak]
   - posix option of vfat is obsolete  [Yoshihiro Takahashi]
   - properly ignore comments in /etc/filesystems  [Mike Frysinger]
po:
   - merge changes  [Karel Zak]
   - update ja.po (from translationproject.org)  [Makoto Kato]
   - update pl.po (from translationproject.org)  [Jakub Bogusz]
   - update vi.po (from translationproject.org)  [Clytie Siddall]
swapon:
   - remove " (deleted)" from filenames from /proc/swaps  [Karel Zak]
wipefs:
   - cleanup usage() and man page  [Karel Zak]
-- 
 Karel Zak  <kzak@redhat.com>
