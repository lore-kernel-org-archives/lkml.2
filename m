Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422679Ab2GMPON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:14:13 -0400
Received: from mx2.netapp.com ([216.240.18.37]:21127 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab2GMPOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:14:12 -0400
X-IronPort-AV: E=Sophos;i="4.77,579,1336374000"; 
   d="scan'208";a="662883077"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        "Linux Kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Please pull NFS client bugfixes
Thread-Topic: [GIT PULL] Please pull NFS client bugfixes
Thread-Index: AQHNYQomcUtVZlBaeUuU0ipZfIFVOw==
Date: Fri, 13 Jul 2012 15:14:09 +0000
Message-ID: <1342192448.11965.3.camel@lade.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E88614DBF5423446942D7E6A5DD34959@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6DFEM9c015241

The following changes since commit 6b16351acbd415e66ba16bf7d473ece1574cf0bc:

  Linux 3.5-rc4 (2012-06-24 12:53:04 -0700)

are available in the git repository at:

  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.5-4

for you to fetch changes up to f1daf666dd7d097653bd38320248c68084b1febf:

  NFSv4: Fix an NFSv4 mount regression (2012-07-10 13:25:39 -0400)

----------------------------------------------------------------
NFS client bugfixes for Linux 3.5

- Fix an NFSv4 mount regression
- Fix O_DIRECT list manipulation snafus

----------------------------------------------------------------
Trond Myklebust (2):
      NFS: Fix list manipulation snafus in fs/nfs/direct.c
      NFSv4: Fix an NFSv4 mount regression

 fs/nfs/direct.c |    6 +++++-
 fs/nfs/super.c  |    2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
