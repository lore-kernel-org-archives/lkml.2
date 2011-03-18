Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab1CRWjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:39:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:65357 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab1CRWj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:39:28 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=XYJHFtupD_QA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=H4rwjN4yaTAI_FuK7MMA:9 a=gpMLAa9IluojjrwwbZMA:7 a=IKTcH_jwL-jVe2qo8ICfKMcDohsA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Fri, 18 Mar 2011 18:39:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jonathan Andrews <jon@jonshouse.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.38 Cant compile
Message-ID: <20110318223925.GK14675@home.goodmis.org>
References: <1300479562.18471.7.camel@jonspc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300479562.18471.7.camel@jonspc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 08:19:22PM +0000, Jonathan Andrews wrote:
> I didn't get very far... 
> 
> Sorry for posting here but google shed no light on this
> 
> Any constructive comments welcome.
> 
> Cheers,
> Jon
> 
> # make
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CC      arch/x86/kernel/asm-offsets.s
> In file included from /usr/src/linux-2.6.38/arch/x86/include/asm/bitops.h:449,
>                  from include/linux/bitops.h:22,
>                  from include/linux/kernel.h:17,
>                  from /usr/src/linux-2.6.38/arch/x86/include/asm/percpu.h:44,
>                  from /usr/src/linux-2.6.38/arch/x86/include/asm/current.h:5,
>                  from /usr/src/linux-2.6.38/arch/x86/include/asm/processor.h:15,
>                  from /usr/src/linux-2.6.38/arch/x86/include/asm/atomic.h:6,
>                  from include/linux/crypto.h:20,
>                  from arch/x86/kernel/asm-offsets_32.c:7,
>                  from arch/x86/kernel/asm-offsets.c:2:
> /usr/src/linux-2.6.38/arch/x86/include/asm/arch_hweight.h: In function `__arch_hweight32':
> /usr/src/linux-2.6.38/arch/x86/include/asm/arch_hweight.h:29: parse error before string constant
> make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2

Hmm, that happened in the ALTERNATIVE() macro. Could be a config
problem. Could you send me you .config you used.


> 
> # gcc --version
> gcc (GCC) 3.2.2

This is also a pretty old gcc. Pretty much all distros are on 4.*

-- Steve

