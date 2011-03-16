Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab1CPUWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:22:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55913 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab1CPUWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:22:36 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=9QXU0bjljTkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=HMbYz5bvLV9qGdviWvIA:9 a=iO9LGUtj3SKfjII-8MzfakOS6xQA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Typo in linux-2.6.38/arch/x86/kernel/entry_32.S
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Vlette <eric.valette@free.fr>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4D8118F7.5060107@free.fr>
References: <4D80B7EE.40706@Free.fr>
	 <20110316195210.GA14675@home.goodmis.org>  <4D8118F7.5060107@free.fr>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 16 Mar 2011 16:22:34 -0400
Message-ID: <1300306954.16880.51.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 21:09 +0100, Eric Vlette wrote:
> On 16/03/2011 20:52, Steven Rostedt wrote:
> > On Wed, Mar 16, 2011 at 02:15:26PM +0100, Eric Valette wrote:
> >> Hi,
> >>
> >> Trying to compile 2.6.38, I found the follwoing bug. Compiler barks...
> > 
> > New compiler? (new binutils more likely)
> 
> Maybe. I use debian unstable + experimental and upgrade packages almost
> everyday...

You probably have new binutils.

What does "as --version" give you. Binutils 2.21... ?

I think it was 2.21 that started giving problems.

> 
> >>
> >> diff linux-2.6.38/arch/x86/kernel/entry_32.S
> >> linux-2.6.38/arch/x86/kernel/entry_32.S~
> >> 1416c1416
> >> < END(async_page_fault)
> >> ---
> >>> END(apf_page_fault)
> 
> But obviously the begin end is not symmetric as in other function.

Right, there was a discussion before about this causing issues with new
binutils, and I think Ingo or Thomas said that they had patches to fix
these for x86. Which this looks like one.

The old binutils never complained.

-- Steve


