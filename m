Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab2LMAoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 19:44:30 -0500
Received: from mx2.netapp.com ([216.240.18.37]:12322 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab2LMAo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 19:44:28 -0500
X-IronPort-AV: E=Sophos;i="4.84,269,1355126400"; 
   d="scan'208";a="718716105"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Sven Wegener <sven.wegener@stealer.net>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] NFSv4: Check for buffer length in
 __nfs4_get_acl_uncached
Thread-Topic: [PATCH] NFSv4: Check for buffer length in
 __nfs4_get_acl_uncached
Thread-Index: AQHN2L55EH39ydWvLEy/Vd1g8d70vpgV5CEQ
Date: Thu, 13 Dec 2012 00:44:26 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA911929358@SACEXCMBX04-PRD.hq.netapp.com>
References: <alpine.LNX.2.02.1212130009400.10324@titan.int.lan.stealer.net>
In-Reply-To: <alpine.LNX.2.02.1212130009400.10324@titan.int.lan.stealer.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBD0iVpS022364

> -----Original Message-----
> From: linux-nfs-owner@vger.kernel.org [mailto:linux-nfs-
> owner@vger.kernel.org] On Behalf Of Sven Wegener
> Sent: Wednesday, December 12, 2012 6:15 PM
> To: Myklebust, Trond
> Cc: linux-nfs@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] NFSv4: Check for buffer length in
> __nfs4_get_acl_uncached
> 
> Commit 1f1ea6c "NFSv4: Fix buffer overflow checking in
> __nfs4_get_acl_uncached" accidently dropped the checking for too small
> result buffer length.
> 
> If someone uses getxattr on "system.nfs4_acl" on an NFSv4 mount
> supporting ACLs, the ACL has not been cached and the buffer suplied is too
> short, we still copy the complete ACL, resulting in kernel and user space
> memory corruption.
> 
> Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
> Cc: stable@kernel.org
> ---
>  fs/nfs/nfs4proc.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Resending, because it did not get any response.

Sorry. I've already applied it to the nfs-for-next branch on git.linux-nfs.org, so it should go in during this merge window.

Cheers
  Trond
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
