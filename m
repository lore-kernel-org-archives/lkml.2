Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab1CPTwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:52:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60157 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab1CPTwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:52:13 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=9QXU0bjljTkA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=m_6j1hJvbv8mcrs9Oe4A:9 a=Lj9Lg0fEEpUECzEd14LsYVUFEaQA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Wed, 16 Mar 2011 15:52:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Valette <Eric.Valette@Free.fr>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Typo in linux-2.6.38/arch/x86/kernel/entry_32.S
Message-ID: <20110316195210.GA14675@home.goodmis.org>
References: <4D80B7EE.40706@Free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D80B7EE.40706@Free.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 02:15:26PM +0100, Eric Valette wrote:
> Hi,
> 
> Trying to compile 2.6.38, I found the follwoing bug. Compiler barks...

New compiler? (new binutils more likely)

> 
> diff linux-2.6.38/arch/x86/kernel/entry_32.S
> linux-2.6.38/arch/x86/kernel/entry_32.S~
> 1416c1416
> < END(async_page_fault)
> ---
> > END(apf_page_fault)
> 

Ingo and Thomas,

IIRC, you have patches to fix these, right?

Thanks,

-- Steve

