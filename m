Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1AKDsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:48:45 -0500
Received: from smtp-out.google.com ([216.239.44.51]:34320 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab1AKDsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:48:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=t+wMiLNK4zi3XLKiMeuttdBWyNeYxVtTsfzwghPJ6NE+fI3H/WPQdEpuMXLBGS1gFy
         HfZlpRyh2vChe9TMx2dA==
Date: Mon, 10 Jan 2011 19:48:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com
Subject: Re: [PATCH 02/16] x86: Rename x86_32 MAX_APICID to MAX_LOCAL_APIC
In-Reply-To: <1293731369-10851-3-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.00.1101101930430.31039@chino.kir.corp.google.com>
References: <1293731369-10851-1-git-send-email-tj@kernel.org> <1293731369-10851-3-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010, Tejun Heo wrote:

> diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
> index a859ca4..47a30ff 100644
> --- a/arch/x86/include/asm/apicdef.h
> +++ b/arch/x86/include/asm/apicdef.h
> @@ -145,6 +145,7 @@
>  
>  #ifdef CONFIG_X86_32
>  # define MAX_IO_APICS 64
> +# define MAX_LOCAL_APIC 256
>  #else
>  # define MAX_IO_APICS 128
>  # define MAX_LOCAL_APIC 32768

Looks like Yinghai's 56d91f13 already added this, but didn't convert the 
rest of the cases that you did.  With this hunk removed and an updated 
changelog:

Acked-by: David Rientjes <rientjes@google.com>
