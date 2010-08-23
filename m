Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0HWXkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 19:40:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53659 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab0HWXk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 19:40:29 -0400
Message-ID: <4C7306AF.4030202@zytor.com>
Date: Mon, 23 Aug 2010 16:39:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.osdl.org,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Removing VMI kernel support from 2.6.37
References: <1282600151.19396.22.camel@ank32.eng.vmware.com>
In-Reply-To: <1282600151.19396.22.camel@ank32.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2010 02:49 PM, Alok Kataria wrote:
> Hi Peter,
> 
> Removal of VMI(VMware's para-virtualization technique) is scheduled for
> 2.6.37, I was wondering what would be the right time frame for
> submitting a patch which does that. Does the x86-tip tree have any next
> branch where we can park this patch ?
> 
> Below is the patch for your reference which just removes VMI specific
> bits, applies on top of x86-tip.
> 
> There is also an opportunity to remove the alloc_pmd_clone hook from
> paravirt side of the things. This interface is only used for VMI, will
> send a follow-on patch later on to do that though.
> 

That would be nice.  In the meantime I have queued up your patch.

	-hpa
