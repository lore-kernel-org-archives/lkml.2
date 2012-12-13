Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab2LMPyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:54:23 -0500
Received: from mx12.netapp.com ([216.240.18.77]:29207 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab2LMPyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:54:21 -0500
X-IronPort-AV: E=Sophos;i="4.84,274,1355126400"; 
   d="scan'208";a="237776"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "ycnian@gmail.com" <ycnian@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH] nfs: Remove duplicate function declaration in internal.h
Thread-Topic: [PATCH] nfs: Remove duplicate function declaration in
 internal.h
Thread-Index: AQHN2P3D4VIfrTXeoUaULaugNw2hu5gXaFeA
Date: Thu, 13 Dec 2012 15:54:19 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA91192BF27@SACEXCMBX04-PRD.hq.netapp.com>
References: <1355380654-10949-1-git-send-email-ycnian@gmail.com>
In-Reply-To: <1355380654-10949-1-git-send-email-ycnian@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.117]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BBA4B400CEEE2D499C679643227F0A5F@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBDFsTWS028030

On Thu, 2012-12-13 at 14:37 +0800, ycnian@gmail.com wrote:
> From: Yanchuan Nian <ycnian@gmail.com>
> 
> Remove duplicate function declaration in internal.h
> 
> Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
> ---
>  fs/nfs/internal.h |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
> index 59b133c..440674f 100644
> --- a/fs/nfs/internal.h
> +++ b/fs/nfs/internal.h
> @@ -409,9 +409,6 @@ extern struct nfs_write_header *nfs_writehdr_alloc(void);
>  extern void nfs_writehdr_free(struct nfs_pgio_header *hdr);
>  extern int nfs_generic_flush(struct nfs_pageio_descriptor *desc,
>  			     struct nfs_pgio_header *hdr);
> -extern void nfs_pageio_init_write(struct nfs_pageio_descriptor *pgio,
> -			struct inode *inode, int ioflags,
> -			const struct nfs_pgio_completion_ops *compl_ops);
>  extern void nfs_pageio_reset_write_mds(struct nfs_pageio_descriptor *pgio);
>  extern void nfs_writedata_release(struct nfs_write_data *wdata);
>  extern void nfs_commit_free(struct nfs_commit_data *p);

nfs_pageio_init_read() was suffering from the same problem, so I added
that to this patch and applied.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
