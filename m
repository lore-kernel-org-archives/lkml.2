Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1EXG0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:26:20 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:25306 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751763Ab1EXG0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:26:19 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18sM/iZ0wxt5Ay8cIiUnP6k
Date: Tue, 24 May 2011 09:26:12 +0300
From: Tony Lindgren <tony@atomide.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v5 15/19] ARM: LPAE: Add support for
 cpu_v7_do_(suspend|resume)
Message-ID: <20110524062611.GA30799@atomide.com>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
 <1304859098-10760-16-git-send-email-catalin.marinas@arm.com>
 <20110518072737.GC6815@atomide.com>
 <1305897667.2788.98.camel@e102109-lin.cambridge.arm.com>
 <alpine.LFD.2.00.1105201407480.14430@xanadu.home>
 <BANLkTimC7dC3P9NQC8BuED9HbdmP1nbZhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimC7dC3P9NQC8BuED9HbdmP1nbZhQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for the delay in replying, we got a baby girl last Thursday :)

* Catalin Marinas <catalin.marinas@arm.com> [110523 00:05]:
> On 20 May 2011 19:09, Nicolas Pitre <nico@fluxnic.net> wrote:
> > On Fri, 20 May 2011, Catalin Marinas wrote:
> >> On Wed, 2011-05-18 at 08:27 +0100, Tony Lindgren wrote:
> >> > Do we really need all this ifdef else throughout this series?
> >> >
> >> > I think we already have things in place to do this dynamically
> >> > like we already do for thumb, smp_on_up, v6 vs v7 and so on.
> >>
> >> By dynamically, do you mean at run-time? We won't be able to compile
> >> both classic and LPAE in the same kernel, there is just too much
> >> difference between them (2 vs 3 levels of page tables - LPAE is an
> >> entirely new format).

OK

> >> If you mean some simpler macros like what we have for ARM/THUMB to
> >> reduce the number of lines, I'm fine with it though we don't always have
> >> a 1:1 mapping between LPAE and non-LPAE instructions.
> >>
> >> Alternatively, I'm happy to create a separate proc-v7lpae.S file.
> >
> > That would probably be the best option.
> 
> OK, I'll move this code to a separate file. The v7 setup code got
> pretty hard to read.

Separate file or macros sounds good to me too depending on how much
of existing code you can recycle.

Regards,

Tony
