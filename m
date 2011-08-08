Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab1HHO5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:57:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab1HHO5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:57:38 -0400
Date: Mon, 8 Aug 2011 15:57:34 +0100
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, hpa@zytor.com, bruno@ioda-net.ch, mjg@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Add reboot quirk for Dell Precision M4600
Message-ID: <20110808145734.GX19099@suse.de>
References: <20110727125651.GH3010@suse.de>
 <20110806065635.GE13220@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110806065635.GE13220@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 06, 2011 at 08:56:35AM +0200, Ingo Molnar wrote:
> 
> * Mel Gorman <mgorman@suse.de> wrote:
> 
> > ACPI reboot does not work for Dell Precision M4600. Detect this
> > machine via DMI and force the use of the PCI reboot method.
> >     
> > Reported-and-tested-by: Bruno Friedmann <bruno@ioda-net.ch>
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > ---
> >  arch/x86/kernel/reboot.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> Weird - ACPI is the default Windows method of reboot - how come it 
> does not work on that box? Does Windows work around this specific 
> machine (unlikely), or is our ACPI boot sequence not 100% compatible 
> with the Windows method (more likely IMO)?
> 

I have no idea and am not well versed on how this sort of problem is
normally investigated.

As Matthew is the person most likely to be able to fix this, I'll defer
to him. Matthew, would you prefer a quirk be added or hold off until
there is time to investigate an alternative?

-- 
Mel Gorman
SUSE Labs
