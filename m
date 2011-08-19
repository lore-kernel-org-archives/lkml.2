Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab1HSGQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 02:16:59 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:55127 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1HSGQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 02:16:56 -0400
Date: Fri, 19 Aug 2011 08:16:37 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: fix _TIF_SINGLE_STEP definition
Message-ID: <20110819081637.76e52a6a@mschwide>
In-Reply-To: <20110818163702.GF20085@htj.dyndns.org>
References: <20110818163702.GF20085@htj.dyndns.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011 18:37:02 +0200
Tejun Heo <tj@kernel.org> wrote:

> _TIF_SINGLE_STEP is incorrectly defined as 1<<TIF_FREEZE.  Fix it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  arch/s390/include/asm/thread_info.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: work/arch/s390/include/asm/thread_info.h
> ===================================================================
> --- work.orig/arch/s390/include/asm/thread_info.h
> +++ work/arch/s390/include/asm/thread_info.h
> @@ -117,7 +117,7 @@ static inline struct thread_info *curren
>  #define _TIF_SIE		(1<<TIF_SIE)
>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>  #define _TIF_31BIT		(1<<TIF_31BIT)
> -#define _TIF_SINGLE_STEP	(1<<TIF_FREEZE)
> +#define _TIF_SINGLE_STEP	(1<<TIF_SINGLE_STEP)
>  #define _TIF_FREEZE		(1<<TIF_FREEZE)
> 
>  #ifdef CONFIG_64BIT

Whoa, that has been "unfixed" by git commit 5e9a26928f550157..
Nice catch!

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

