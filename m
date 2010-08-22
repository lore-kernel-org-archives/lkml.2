Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab0HVRCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 13:02:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab0HVRCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 13:02:19 -0400
Date: Sun, 22 Aug 2010 12:56:45 -0400
From: Neil Horman <nhorman@redhat.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [Patch] vmcore: it is not experimental any more
Message-ID: <20100822165645.GB29702@hmsreliant.think-freely.org>
References: <20100818064817.GA5676@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100818064817.GA5676@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 02:48:28PM +0800, Américo Wang wrote:
> 
> We use vmcore in our production kernel for a long time,
> it is pretty stable now. So I don't think we need to mark
> it as experimental any more.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
> index 50f8f06..3df4257 100644
> --- a/fs/proc/Kconfig
> +++ b/fs/proc/Kconfig
> @@ -33,7 +33,7 @@ config PROC_KCORE
>  	depends on PROC_FS && MMU
>  
>  config PROC_VMCORE
> -        bool "/proc/vmcore support (EXPERIMENTAL)"
> +        bool "/proc/vmcore support"
>          depends on PROC_FS && CRASH_DUMP
>  	default y
>          help
Acked-by: Neil Horman <nhorman@tuxdriver.com>

