Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab0KSMCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 07:02:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:51098 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab0KSMCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 07:02:51 -0500
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
From: Peter Zijlstra <peterz@infradead.org>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>
In-Reply-To: <AANLkTik3ujs7-tMNUuk33wuMXFm+iusspMcR=yjPXtn_@mail.gmail.com>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
	 <1290165768.2109.1537.camel@laptop>
	 <AANLkTik3ujs7-tMNUuk33wuMXFm+iusspMcR=yjPXtn_@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 19 Nov 2010 13:02:53 +0100
Message-ID: <1290168173.2109.1565.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 19:54 +0800, huang ying wrote:
> 
> On Fri, Nov 19, 2010 at 7:22 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2010-11-19 at 16:10 +0800, Huang Ying wrote:
> >> Hi, Len,
> >>
> >> This is used by APEI ERST and GEHS. But it is a generic hardware
> >> error reporting mechanism and can be used by other hardware error
> >> reporting mechanisms such as EDAC, PCIe AER, Machine Check, etc.
> >>
> >> The patchset is split from the original APEI patchset to make it
> >> explicit that this is a generic mechanism, not APEI specific bits.
> >>
> >> [PATCH 1/2] Generic hardware error reporting mechanism
> >> [PATCH 2/2] Hardware error record persistent support
> >
> > You call it generic, does that mean the EDAC guys agree, does it work on
> > AMD and IA64?
> 
> I call it "generic", because it can be used by EDAC, PCIe AER, Machine
> Check, etc to report hardware errors, and it can work on  AMD and
> IA64. 

1) that's not a complete answer -- I asked to the EDAC guys agree? Have
you even tried talking to them?

and 2) 'can' is not the right word here, I though we'd all agreed to
talk about this and agree on some approach before littering the kernel
with tiny special case interfaces.. which this will be if EDAC and
others don't agree with you.

So I want a firm agreement of all parties interested that this is the
way forward, if not you already have my NAK.

