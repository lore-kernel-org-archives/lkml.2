Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab1EZV0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 17:26:11 -0400
Received: from unicorn.mansr.com ([78.86.181.103]:47977 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210Ab1EZV0J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 17:26:09 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?iso-8859-1?Q?M=E5ns_Rullg?= =?iso-8859-1?Q?=E5rd?= 
	<mans@mansr.com>,
        linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org
Subject: Re: [PATCH] ARM: Do not allow unaligned accesses when CONFIG_ALIGNMENT_TRAP
References: <20110523111648.10474.78396.stgit@e102109-lin.cambridge.arm.com>
	<20110523132124.GI17672@n2100.arm.linux.org.uk>
	<1306229953.19557.14.camel@e102109-lin.cambridge.arm.com>
	<yw1xipt0p4i9.fsf@unicorn.mansr.com>
	<BANLkTi=xLE9gP5YOdr9dR0DfsY1Ymzxu+w@mail.gmail.com>
	<20110524171331.GA2941@arm.com>
	<20110525111405.GA12010@e102109-lin.cambridge.arm.com>
	<20110525124348.GA2340@arm.com> <yw1xaaeanbxe.fsf@unicorn.mansr.com>
	<BANLkTim2TOZgB-3Vkv5RcK572Qr07s3=CA@mail.gmail.com>
	<1306429854.26735.9.camel@e102144-lin.cambridge.arm.com>
	<alpine.LFD.2.00.1105261650330.3207@xanadu.home>
	<4DDEC1C0.20807@linux.intel.com>
Date: Thu, 26 May 2011 22:26:07 +0100
In-Reply-To: <4DDEC1C0.20807@linux.intel.com> (Andi Kleen's message of "Thu,
	26 May 2011 14:10:24 -0700")
Message-ID: <yw1x62oxf91s.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@linux.intel.com> writes:

>> It is possible that -fconserve-stack is still valuable on ARM given that
>> it is also used with -mno-unaligned-access for other things than
>> structure packing on the stack, and therefore its merits can be debated
>> independently from the alignment issue at hand.
>
> The big advantage of -fconserve-stack is that it throttles the inliner
> if the inlining would cause too much stack growth. This is something
> you likely want on ARM too, especially as code gets more and more
> complex.

Is there no way to get that effect without also activating the
aggressive packing?

-- 
Måns Rullgård
mans@mansr.com
