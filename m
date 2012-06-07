Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202Ab2FGIXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:23:30 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:34953 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758749Ab2FGIX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:23:26 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shai@scalemp.com
Subject: Re: [PATCH RESEND] fs: Move bh_cachep to the __read_mostly section
Date: Thu, 07 Jun 2012 11:23:16 +0300
Message-ID: <2326820.48IRXJDP2Q@vlad>
Organization: ScaleMP Ltd.
User-Agent: KMail/4.8.3 (Linux/3.2.0-24-generic; KDE/4.8.3; i686; ; )
In-Reply-To: <2325453.OX7ktP55U1@vlad>
References: <2325453.OX7ktP55U1@vlad>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2012 14:58:42 Vlad Zolotarov wrote:
> From: Shai Fultheim <shai@scalemp.com>
> 
> bh_cachep is only written to once on initialization, so move it to the
> __read_mostly section.
> 
> Signed-off-by: Shai Fultheim <shai@scalemp.com>
> Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
> ---
>  fs/buffer.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index ad5938c..838a9cf 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3152,7 +3152,7 @@ SYSCALL_DEFINE2(bdflush, int, func, long, data)
>  /*
>   * Buffer-head allocation
>   */
> -static struct kmem_cache *bh_cachep;
> +static struct kmem_cache *bh_cachep __read_mostly;
> 
>  /*
>   * Once the number of bh's in the machine exceeds this level, we start

Alexander, could u, pls., take a look at this patch? Could u, pls., update me 
about its state. Should I respin?

thanks in advance,
vlad

