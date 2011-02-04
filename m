Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1BDU1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 15:27:04 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15021 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1BDU1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 15:27:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 04 Feb 2011 12:14:56 -0800
Date: Fri, 4 Feb 2011 12:26:40 -0800
From: rmorell@nvidia.com
To: Greg KH <gregkh@suse.de>
Cc: Olof Johansson <olof@lixom.net>, Greg KH <greg@kroah.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Benoit Goby <benoit@android.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Oliver Neukum <oliver@neukum.org>, Erik Gilling <konkers@android.com>,
        Colin Cross <ccross@android.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 3/3] USB: ehci: tegra: Align DMA transfers to 32 bytes
Message-ID: <20110204202640.GC1744@morell.nvidia.com>
References: <1295559715-14264-1-git-send-email-rmorell@nvidia.com>
 <1296097609-32302-4-git-send-email-rmorell@nvidia.com>
 <20110204194954.GA25180@kroah.com>
 <AANLkTinRtch4Pvr3GLz5wZU2xkG3FMJxxzSNAdParA7j@mail.gmail.com>
 <20110204201616.GA12482@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110204201616.GA12482@suse.de>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 12:16:16PM -0800, Greg KH wrote:
> On Fri, Feb 04, 2011 at 12:14:54PM -0800, Olof Johansson wrote:
> > On Fri, Feb 4, 2011 at 11:49 AM, Greg KH <greg@kroah.com> wrote:
> > > This file doesn't seem to be in any tree that I can find, including my
> > > own, so I can't apply this patch.
> > >
> > > What am I supposed to do with it?
> > 
> > It hasn't been posted for upstream yet, so nothing for you to do. The
> > driver will be posted for review soon, hopefully in time for .39.
> 
> Then why would someone send me a patch for it already?

Sorry, this is my fault.  My immediate need is to get this merged into
our release linux-tegra-2.6.36 branch, but wanted to get broad review
for the change since it affects USB core code.  I figured that it will
be easier to push the full driver into the USB tree with this part out
of the way already, anyway.

Thanks,
Robert
