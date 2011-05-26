Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab1EZRSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:18:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33314 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab1EZRSb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:18:31 -0400
MIME-Version: 1.0
Message-ID: <f6761efd-443c-44e0-bc40-9245a59cde63@default>
Date: Thu, 26 May 2011 10:17:44 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, konrad.wilk@oracle.com
Subject: [GIT PULL] mm/vfs/fs:cleancache for 2.6.40 merge window
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090205.4DDE8B49.00F4:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus --

Please pull

git://git.kernel.org/pub/scm/linux/kernel/git/djm/tmem.git for-linus

since git commit 61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf
Linus Torvalds (1):

	Linux 2.6.39

This is version 9 of cleancache -- the only difference from version 8
(which was previously posted to lkml) is that the config default has
been corrected to "n".

As with previous versions, this set of commits includes the Xen
tmem commit as Jeremy Fitzhardinge requested.  The other user of
cleancache, zcache, is in the drivers/staging tree as of 2.6.39
and I continue to make progress on other cleancache users such
as RAMster.

Diffstat:
 Documentation/ABI/testing/sysfs-kernel-mm-cleancache |   11 +
 Documentation/vm/cleancache.txt                      |  278 ++++++++++
 arch/x86/include/asm/xen/hypercall.h                 |    7 +
 drivers/xen/Makefile                                 |    1 +
 drivers/xen/tmem.c                                   |  264 +++++++++
 fs/btrfs/extent_io.c                                 |    9 +
 fs/btrfs/super.c                                     |    2 +
 fs/buffer.c                                          |    5 +
 fs/ext3/super.c                                      |    2 +
 fs/ext4/super.c                                      |    2 +
 fs/mpage.c                                           |    7 +
 fs/ocfs2/super.c                                     |    2 +
 fs/super.c                                           |    3 +
 include/linux/cleancache.h                           |  122 ++++
 include/linux/fs.h                                   |    5 +
 include/xen/interface/xen.h                          |   22 +
 mm/Kconfig                                           |   23 +
 mm/Makefile                                          |    1 +
 mm/cleancache.c                                      |  244 ++++++++
 mm/filemap.c                                         |   11 +
 mm/truncate.c                                        |    6 +
 21 files changed, 1027 insertions(+), 0 deletions(-)

Apologies that this is late in the window... I have been on
vacation.  Also apologies in advance for any protocol errors
due to my newbieness.

Thanks,
Dan

