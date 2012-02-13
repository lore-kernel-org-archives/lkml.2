Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab2BMWgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 17:36:31 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46278 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755502Ab2BMWg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 17:36:29 -0500
X-Sasl-enc: 4h/kAtl2QQiF5z8bImJ4I0gXH/2bPhqCBh5tE043Y7LS 1329172588
Date: Mon, 13 Feb 2012 14:26:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Renninger <trenn@suse.de>, Ben Hutchings <ben@decadent.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-pm@vger.kernel.org, Dave Jones <davej@redhat.com>,
        cpufreq@vger.kernel.org
Subject: Re: [PATCH 0/5] Clean up x86 CPU auto-loading
Message-ID: <20120213222607.GA19465@kroah.com>
References: <1329000256.325.48.camel@deadeye>
 <201202130010.57492.trenn@suse.de>
 <4F3866D4.9060209@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3866D4.9060209@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 12, 2012 at 05:26:44PM -0800, H. Peter Anvin wrote:
> On 02/12/2012 03:10 PM, Thomas Renninger wrote:
> > On Saturday 11 February 2012 23:44:16 Ben Hutchings wrote:
> >> This series fixes a number of apparent bugs in the recent changes to
> >> enable auto-loading by x86 CPU ID.
> > 
> > These all look correct.
> > I should have spotted the intel_idle modifications myself.
> > Good catch(es).
> > 
> > Greg: I expect these should get queued in your driver-core-next branch?
> > 
> 
> Either that or we can carry them in -tip as x86 patches, since there
> isn't a pending conflict this time.

Ok, if there are no dependancies on the driver-core-next tree, please
take this through the x86 trees.

thanks,

greg k-h
