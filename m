Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab0LQXfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:35:37 -0500
Received: from cantor.suse.de ([195.135.220.2]:46776 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160Ab0LQXfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:35:36 -0500
Date: Fri, 17 Dec 2010 15:35:27 -0800
From: Greg KH <gregkh@suse.de>
To: Oliver Neukum <oliver@neukum.org>
Cc: rmorell@nvidia.com, David Brownell <dbrownell@users.sourceforge.net>,
        Benoit Goby <benoit@android.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Olof Johansson <olof@lixom.net>, Erik Gilling <konkers@android.com>,
        Colin Cross <ccross@android.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] USB: ehci: tegra: Align DMA transfers to 32 bytes
Message-ID: <20101217233527.GA31162@suse.de>
References: <1292623129-26361-1-git-send-email-rmorell@nvidia.com>
 <20101217224221.GE25105@morell.nvidia.com>
 <20101217230940.GB21147@suse.de>
 <201012180017.41391.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012180017.41391.oliver@neukum.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 12:17:40AM +0100, Oliver Neukum wrote:
> Am Samstag, 18. Dezember 2010, 00:09:40 schrieb Greg KH:
> > I still don't like it, it feels like a hack that is not going to be able
> > to be maintained very well.
> > 
> > And I still think the individual drivers should be fixed...
> > 
> 
> But they are not buggy. The USB API was written under the
> assumption that HCDs can deal with byte level granularity and alignment.
> Hence the network driver pass DMA-able memory with an alignment
> that suits them.

Ok, fair enough.

But I still don't like that urb flag stuff as a solution to this...

thanks,

greg k-h
