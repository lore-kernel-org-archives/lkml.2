Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab2JVRmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:42:32 -0400
Received: from mx2.netapp.com ([216.240.18.37]:57172 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600Ab2JVRmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:42:31 -0400
X-IronPort-AV: E=Sophos;i="4.80,631,1344236400"; 
   d="scan'208";a="703033999"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        "Linux Kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Please pull NFS client bugfixes...
Thread-Topic: [GIT PULL] Please pull NFS client bugfixes...
Thread-Index: AQHNsHyajL9XhJlKjUG5J4Ve8yCD/A==
Date: Mon, 22 Oct 2012 17:42:28 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA909289258@SACEXCMBX04-PRD.hq.netapp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <12B320E4EC0AEE448105EDA60D4DB07F@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9MHgdQp030676

Hi Linus,

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.7-2

for you to fetch changes up to e9b7e91745fa9df94900c8ab08e633f336686098:

  NFSv4: Fix the return value for nfs_callback_start_svc (2012-10-16 13:14:42 -0400)

----------------------------------------------------------------
NFS client bugfixes for Linux 3.7

- Do not call pnfs_return_layout() from an rpciod context
- nfs4_ds_disconnect can cause Oopses. Kill it...
- Fix the return value for nfs_callback_start_svc
- Fix a number of compile warnings

----------------------------------------------------------------
Trond Myklebust (6):
      NFSv4.1: Kill nfs4_ds_disconnect()
      NFSv4.1: Do not call pnfs_return_layout() from an rpciod context
      NFSv4.1: Use kcalloc() to allocate zeroed arrays instead of kzalloc()
      NFSv4: fs/nfs/nfs4getroot.c needs to include "internal.h"
      NFSv4.1: Declare osd_pri_2_pnfs_err(), objio_init_read/write to be static
      NFSv4: Fix the return value for nfs_callback_start_svc

 fs/nfs/callback.c            |  2 +-
 fs/nfs/nfs4filelayout.c      | 21 ++++++++++++++++-----
 fs/nfs/nfs4filelayout.h      |  1 -
 fs/nfs/nfs4filelayoutdev.c   | 22 ----------------------
 fs/nfs/nfs4getroot.c         |  1 +
 fs/nfs/objlayout/objio_osd.c |  6 +++---
 fs/nfs/pnfs.h                |  1 +
 7 files changed, 22 insertions(+), 32 deletions(-)

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
