Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab1EZVvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 17:51:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35299 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758241Ab1EZVvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 17:51:15 -0400
Date: Thu, 26 May 2011 22:51:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Will Deacon <will.deacon@arm.com>,
        =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, ak@linux.intel.com,
        Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Do not allow unaligned accesses when
	CONFIG_ALIGNMENT_TRAP
Message-ID: <20110526215101.GL24876@n2100.arm.linux.org.uk>
References: <1306229953.19557.14.camel@e102109-lin.cambridge.arm.com> <yw1xipt0p4i9.fsf@unicorn.mansr.com> <BANLkTi=xLE9gP5YOdr9dR0DfsY1Ymzxu+w@mail.gmail.com> <20110524171331.GA2941@arm.com> <20110525111405.GA12010@e102109-lin.cambridge.arm.com> <20110525124348.GA2340@arm.com> <yw1xaaeanbxe.fsf@unicorn.mansr.com> <BANLkTim2TOZgB-3Vkv5RcK572Qr07s3=CA@mail.gmail.com> <1306429854.26735.9.camel@e102144-lin.cambridge.arm.com> <alpine.LFD.2.00.1105261650330.3207@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1105261650330.3207@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 05:03:39PM -0400, Nicolas Pitre wrote:
> It is possible that -fconserve-stack is still valuable on ARM given that 
> it is also used with -mno-unaligned-access for other things than 
> structure packing on the stack, and therefore its merits can be debated 
> independently from the alignment issue at hand.

Catalin said in his mail "I haven't tried with -mno-unaligned-access, I
suspect the variables on the stack would be aligned.".  So I don't think
we know enough to say whether -mno-unaligned-access avoids the stack
packing.
