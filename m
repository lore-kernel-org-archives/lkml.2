Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab0EGU5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 16:57:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756082Ab0EGU5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 16:57:21 -0400
Date: Fri, 7 May 2010 13:54:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alek Du <alek.du@intel.com>, Feng Tang <feng.tang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jacob Pan <jacob.jun.pan@intel.com>,
       Arjan van de Ven <arjan.van.de.ven@intel.com>
Subject: Re: RFD: Should we remove the HLT check?  (was Re: [PATCH 1/8] x86:
 avoid check hlt if no timer interrupts)
In-Reply-To: <4BE4791B.1060304@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1005071354310.901@i5.linux-foundation.org>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273254108-3234-2-git-send-email-jacob.jun.pan@linux.intel.com> <4BE478C1.2060602@zytor.com> <4BE4791B.1060304@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 May 2010, Arjan van de Ven wrote:

> On 5/7/2010 13:32, H. Peter Anvin wrote:
> > 
> > I really wish I knew the exact systems affected by the HLT bug.  If I
> > remember correctly, it was some 386 systems -- or possibly 486 systems
> > as well -- a very long time ago.  This test just provides a diagnosis if
> > the system really is bad (it hangs with an obvious message) at the cost
> > of some 40 ms to the system boot time.  I suspect C1 (HLT) being broken
> > is not anywhere close to the predominant power management problem in the
> > current day, and as such I'm wondering if this particular test hasn't
> > outlived its usefulness.
> > 
> > Thoughts?
> 
> we could at least hide it behind the "don't run on pentium or newer" config
> options..

Ack. That would take care of all relevant machines.

		Linus
