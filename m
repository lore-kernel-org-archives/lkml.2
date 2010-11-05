Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab0KEUzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 16:55:23 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42350 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab0KEUzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 16:55:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nU0SGLIB2lXUN7QIPvJadH8K/8NPKwubjXuV8bcgCnNuZiwuElEltg/y/gHj8UFYsc
         DQI8Gtfk6IRxO+XiZMfNDffsimOtx7EDwZPs3rEBJyF4f3mLOB0mGW9OKuuOJ+EBlcwx
         EIVbgFqp06VFg5WLt8D0jtald4KFKmgEDl/V4=
Date: Fri, 5 Nov 2010 23:55:16 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [RFC 1/4]x86: cleanup vector usage
Message-ID: <20101105205516.GB5678@lenovo>
References: <1288766658.23014.114.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288766658.23014.114.camel@sli10-conroe>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 02:44:18PM +0800, Shaohua Li wrote:
> Cleanup the vector usage and make them continuous if possible.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
...
> -#define X86_PLATFORM_IPI_VECTOR		0xed
> +#define X86_PLATFORM_IPI_VECTOR		0xf7
>  
>  /*
>   * IRQ work vector:
>   */
> -#define IRQ_WORK_VECTOR			0xec
> +#define IRQ_WORK_VECTOR			0xf6
>  
> -#define UV_BAU_MESSAGE			0xea
> +#define UV_BAU_MESSAGE			0xf5
>  
>  /*
>   * Self IPI vector for machine checks
>   */
> -#define MCE_SELF_VECTOR			0xeb
> +#define MCE_SELF_VECTOR			0xf4
>  
>  /* Xen vector callback to receive events in a HVM domain */
> -#define XEN_HVM_EVTCHN_CALLBACK		0xe9
> +#define XEN_HVM_EVTCHN_CALLBACK		0xf3
> +

 Hi Li, this is not just a cleanup -- irq priority were changed as
well, but I suppose it's harmless ;)
 
  Cyrill
