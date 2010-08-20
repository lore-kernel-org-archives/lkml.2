Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751030Ab0HTEnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 00:43:18 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:44267 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750787Ab0HTEnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 00:43:16 -0400
Message-ID: <4C6E06D7.5060101@snapgear.com>
Date: Fri, 20 Aug 2010 14:38:47 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: uClinux development list <uclinux-dev@uclinux.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [uClinux-dev] [PATCH] m68knommu: whitespace cleanup in 68328/entry.S
References: <20100817165239.GA16734@frolo.macqel>
In-Reply-To: <20100817165239.GA16734@frolo.macqel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Aug 2010 04:42:19.0575 (UTC) FILETIME=[12A04470:01CB4022]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Philippe,

Philippe De Muyter wrote:
> m68knommu: whitespace cleanup in 68328/entry.S
> 
> Signed-off-by: Philippe De Muyter <phdm@macqel.be>

Thanks, applied to the m68knommu git tree.

Regards
Greg


> diff --git a/arch/m68knommu/platform/68328/entry.S b/arch/m68knommu/platform/68328/entry.S
> --- a/arch/m68knommu/platform/68328/entry.S
> +++ b/arch/m68knommu/platform/68328/entry.S
> @@ -43,7 +43,7 @@ badsys:
>  	jra	ret_from_exception
>  
>  do_trace:
> -	movel	#-ENOSYS,%sp@(PT_OFF_D0)	/* needed for strace*/
> +	movel	#-ENOSYS,%sp@(PT_OFF_D0) /* needed for strace*/
>  	subql	#4,%sp
>  	SAVE_SWITCH_STACK
>  	jbsr	syscall_trace
> @@ -57,7 +57,7 @@ do_trace:
>  	lea	sys_call_table, %a0
>  	jbsr	%a0@(%d1)
>  
> -1:	movel	%d0,%sp@(PT_OFF_D0)		/* save the return value */
> +1:	movel	%d0,%sp@(PT_OFF_D0)	/* save the return value */
>  	subql	#4,%sp			/* dummy return address */
>  	SAVE_SWITCH_STACK
>  	jbsr	syscall_trace
> @@ -71,9 +71,9 @@ ENTRY(system_call)
>  	SAVE_ALL
>  
>  	/* save top of frame*/
> -	pea     %sp@
> -	jbsr    set_esp0
> -	addql   #4,%sp
> +	pea	%sp@
> +	jbsr	set_esp0
> +	addql	#4,%sp
>  
>  	movel	%sp@(PT_OFF_ORIG_D0),%d0
>  
> @@ -88,10 +88,10 @@ ENTRY(system_call)
>  	lea	sys_call_table,%a0
>  	movel	%a0@(%d0), %a0
>  	jbsr	%a0@
> -	movel	%d0,%sp@(PT_OFF_D0)		/* save the return value*/
> +	movel	%d0,%sp@(PT_OFF_D0)	/* save the return value*/
>  
>  ret_from_exception:
> -	btst	#5,%sp@(PT_OFF_SR)		/* check if returning to kernel*/
> +	btst	#5,%sp@(PT_OFF_SR)	/* check if returning to kernel*/
>  	jeq	Luser_return		/* if so, skip resched, signals*/
>  
>  Lkernel_return:
> _______________________________________________
> uClinux-dev mailing list
> uClinux-dev@uclinux.org
> http://mailman.uclinux.org/mailman/listinfo/uclinux-dev
> This message was resent by uclinux-dev@uclinux.org
> To unsubscribe see:
> http://mailman.uclinux.org/mailman/options/uclinux-dev
> 


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
