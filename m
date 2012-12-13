Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab2LMPyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:54:36 -0500
Received: from mx12.netapp.com ([216.240.18.77]:15305 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755933Ab2LMPye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:54:34 -0500
X-IronPort-AV: E=Sophos;i="4.84,274,1355126400"; 
   d="scan'208";a="237830"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "ycnian@gmail.com" <ycnian@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH] nfs: Remove unused list nfs4_clientid_list
Thread-Topic: [PATCH] nfs: Remove unused list nfs4_clientid_list
Thread-Index: AQHN2P3ONLlARxMpGkij7QC9xKXHvJgXaGeA
Date: Thu, 13 Dec 2012 15:54:32 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA91192BF36@SACEXCMBX04-PRD.hq.netapp.com>
References: <1355380672-10982-1-git-send-email-ycnian@gmail.com>
In-Reply-To: <1355380672-10982-1-git-send-email-ycnian@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.117]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F9A5747B8FF28247A31D44631A0E9671@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBDFseGh028035

On Thu, 2012-12-13 at 14:37 +0800, ycnian@gmail.com wrote:
> From: Yanchuan Nian <ycnian@gmail.com>
> 
> This list was designed to store struct nfs4_client in the client side.
> But nfs4_client was obsolete and has been removed from the source code. 
> So remove the unused list.
> 
> Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
> ---
>  fs/nfs/nfs4state.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
> index c351e6b..51c9b0b 100644
> --- a/fs/nfs/nfs4state.c
> +++ b/fs/nfs/nfs4state.c
> @@ -66,7 +66,6 @@
>  
>  const nfs4_stateid zero_stateid;
>  static DEFINE_MUTEX(nfs_clid_init_mutex);
> -static LIST_HEAD(nfs4_clientid_list);
>  
>  int nfs4_init_clientid(struct nfs_client *clp, struct rpc_cred *cred)
>  {

Applied
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
