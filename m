Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab2BMCWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 21:22:45 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58336 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753396Ab2BMCWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 21:22:43 -0500
X-Sasl-enc: 3b6YXYpxuMVr756Fcg7kAp30mGy+QO1r1Kw/uCZveuyA 1329099762
Date: Sun, 12 Feb 2012 18:18:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-pm@vger.kernel.org, Dave Jones <davej@redhat.com>,
        cpufreq@vger.kernel.org
Subject: Re: [PATCH 0/5] Clean up x86 CPU auto-loading
Message-ID: <20120213021847.GA25382@kroah.com>
References: <1329000256.325.48.camel@deadeye>
 <201202130010.57492.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201202130010.57492.trenn@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 12:10:56AM +0100, Thomas Renninger wrote:
> On Saturday 11 February 2012 23:44:16 Ben Hutchings wrote:
> > This series fixes a number of apparent bugs in the recent changes to
> > enable auto-loading by x86 CPU ID.
> 
> These all look correct.
> I should have spotted the intel_idle modifications myself.
> Good catch(es).
> 
> Greg: I expect these should get queued in your driver-core-next branch?

I can take them, unless the x86 maintainers object and want to take them
through their tree.

thanks,

greg k-h
