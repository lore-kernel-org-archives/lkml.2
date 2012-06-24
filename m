Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2FXSGr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 14:06:47 -0400
Received: from mx2.netapp.com ([216.240.18.37]:55060 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab2FXSGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 14:06:46 -0400
X-IronPort-AV: E=Sophos;i="4.77,467,1336374000"; 
   d="scan'208";a="657651854"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Yanchuan Nian <ycnian@gmail.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix a typo in nfs.h
Thread-Topic: [PATCH] Fix a typo in nfs.h
Thread-Index: AQHNUitVoVyflpCE7kq5VrrC6gRjKZcKOSKA
Date: Sun, 24 Jun 2012 18:06:28 +0000
Message-ID: <1340561183.2868.1.camel@lade.trondhjem.org>
References: <CAC5OsZN6gWqTRawvXXf8iw8J4h8wVaASo0ZgU_7kxt-gFAasmA@mail.gmail.com>
In-Reply-To: <CAC5OsZN6gWqTRawvXXf8iw8J4h8wVaASo0ZgU_7kxt-gFAasmA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C92363DCE8DB14EA2EB125D2CE938CB@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5OI7uLO026997

On Mon, 2012-06-25 at 01:03 +0800, Yanchuan Nian wrote:
> This is a trivial patch that fixes a typo in the comment of nfs.h

"Iff" is _not_ a typo... Google it...

> 
> 
> Signed-off-by:Yanchuan Nian <ycnian@gmail.com>
> ---
>  include/linux/nfs.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/include/linux/nfs.h b/include/linux/nfs.h
> index 6d1fb63..be43aaa 100644
> --- a/include/linux/nfs.h
> +++ b/include/linux/nfs.h
> @@ -142,7 +142,7 @@ struct nfs_fh {
>  };
>  
>  /*
> - * Returns a zero iff the size and data fields match.
> + * Returns a zero if the size and data fields match.
>   * Checks only "size" bytes in the data field.
>   */
>  static inline int nfs_compare_fh(const struct nfs_fh *a, const struct
> nfs_fh *b)
> -- 
> 1.7.6

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
