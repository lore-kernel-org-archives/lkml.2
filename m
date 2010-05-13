Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932Ab0EMR7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 13:59:54 -0400
Received: from mail.perches.com ([173.55.12.10]:2232 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372Ab0EMR7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 13:59:52 -0400
Subject: Re: [PATCH] [staging-next] [1] Staging: rtl8187se: fixed space
 style issues in r8180_core.c
From: Joe Perches <joe@perches.com>
To: "Prashant P. Shah" <pshah.mumbai@gmail.com>
Cc: gregkh@suse.de, bzolnier@gmail.com, Larry.Finger@lwfinger.net,
       bernhard@schiffner-limbach.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1273772323-6876-1-git-send-email-pshah.mumbai@gmail.com>
References: <1273772323-6876-1-git-send-email-pshah.mumbai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 10:59:51 -0700
Message-ID: <1273773591.21514.93.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 23:08 +0530, Prashant P. Shah wrote:
>  drivers/staging/rtl8187se/r8180_core.c | 1622 ++++++++++++++++----------------
>  1 files changed, 806 insertions(+), 816 deletions(-)
> 
> diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
> index 84a745b..37be5ae 100644
> --- a/drivers/staging/rtl8187se/r8180_core.c
> +++ b/drivers/staging/rtl8187se/r8180_core.c
> @@ -66,23 +66,23 @@ static int hwseqnum = 0;
>  static int hwwep = 0;
>  static int channels = 0x3fff;
>  
> -#define eqMacAddr(a,b)		( ((a)[0]==(b)[0] && (a)[1]==(b)[1] && (a)[2]==(b)[2] && (a)[3]==(b)[3] && (a)[4]==(b)[4] && (a)[5]==(b)[5]) ? 1:0 )
> -#define cpMacAddr(des,src)	      ((des)[0]=(src)[0],(des)[1]=(src)[1],(des)[2]=(src)[2],(des)[3]=(src)[3],(des)[4]=(src)[4],(des)[5]=(src)[5])
> +#define eqMacAddr(a, b)		(((a)[0] == (b)[0] && (a)[1] == (b)[1] && (a)[2] == (b)[2] && (a)[3] == (b)[3] && (a)[4] == (b)[4] && (a)[5] == (b)[5]) ? 1 : 0)
> +#define cpMacAddr(des, src)		((des)[0] = (src)[0], (des)[1] = (src)[1], (des)[2] = (src)[2], (des)[3] = (src)[3], (des)[4] = (src)[4], (des)[5] = (src)[5])

Just use compare_ether_addr and memcpy directly


