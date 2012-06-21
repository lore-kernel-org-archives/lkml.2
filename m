Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607Ab2FUW6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:58:20 -0400
Received: from mx2.netapp.com ([216.240.18.37]:52121 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760515Ab2FUW6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:58:18 -0400
X-IronPort-AV: E=Sophos;i="4.77,454,1336374000"; 
   d="scan'208";a="657105779"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        "Linux Kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Please pull bugfixes for the NFS client
Thread-Topic: [GIT PULL] Please pull bugfixes for the NFS client
Thread-Index: AQHNUAFOyb/yWOndC0qIw4+C/97lKQ==
Date: Thu, 21 Jun 2012 22:58:01 +0000
Message-ID: <1340319479.18403.3.camel@lade.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <809E3E2BB1F41F4C88FD85403B77CB31@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5LMwQ1h013453

Hi Linus,

The following changes since commit 39a50b42f7026027b54131291ad0f350100eac95:

  Merge branch 'hfsplus' (2012-06-17 14:40:35 -0700)

are available in the git repository at:


  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.5-3

for you to fetch changes up to b1027439dff844675f6c0df97a1b1d190791a699:

  NFS: Force the legacy idmapper to be single threaded (2012-06-20 14:38:11 -0400)

Cheers,
  Trond

----------------------------------------------------------------
NFS client bugfixes for Linux 3.5

Fixes include:
- Fix a write hang due to an uninitalised variable when !defined(CONFIG_NFS_V4)
- Address upcall races in the legacy NFSv4 idmapper
- Remove an O_DIRECT refcounting issue
- Fix a pNFS refcounting bug when the file layout metadata server is also
  acting as a data server
- Fix a pNFS module loading race.

----------------------------------------------------------------
Bryan Schumaker (1):
      NFS: Force the legacy idmapper to be single threaded

Trond Myklebust (4):
      NFSv4.1: Fix umount when filelayout DS is also the MDS
      NFSv4.1: Fix a race in set_pnfs_layoutdriver
      NFS: Fix a refcounting issue in O_DIRECT
      NFS: Initialise commit_info.rpc_out when !defined(CONFIG_NFS_V4)

 fs/nfs/client.c           |    1 -
 fs/nfs/direct.c           |    1 +
 fs/nfs/idmap.c            |   13 ++++++++-----
 fs/nfs/inode.c            |    2 +-
 fs/nfs/pnfs.c             |   13 +++++++++----
 include/linux/nfs_fs_sb.h |    1 +
 6 files changed, 20 insertions(+), 11 deletions(-)

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
