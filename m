Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab1E0J6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:58:32 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44527 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867Ab1E0J6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:58:30 -0400
X-Sasl-enc: 9FPgMzJ7EIurZ6MztnhXoUj9bP1oUVulamDSWrlrMAYb 1306490309
Date: Fri, 27 May 2011 17:59:11 +0800
From: Greg KH <greg@kroah.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Mike Travis <travis@sgi.com>,
        Chris Wright <chrisw@sous-sol.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Mike Habeck <habeck@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [stable] [PATCH 1/7] Intel pci: Check for identity mapping
 candidate using system dma mask
Message-ID: <20110527095911.GA9272@kroah.com>
References: <20110527013221.231071058@gulag1.americas.sgi.com>
 <20110527013221.405688800@gulag1.americas.sgi.com>
 <20110527071838.GA16217@kroah.com>
 <20110527093042.GG21386@elte.hu>
 <20110527094209.GB27062@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527094209.GB27062@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 11:42:09AM +0200, Joerg Roedel wrote:
> On Fri, May 27, 2011 at 05:30:42AM -0400, Ingo Molnar wrote:
> > 
> > * Greg KH <greg@kroah.com> wrote:
> > 
> > > <formletter>
> > > 
> > > This is not the correct way to submit patches for inclusion in the 
> > > stable kernel tree.  Please read 
> > > Documentation/stable_kernel_rules.txt for how to do this properly.
> > > 
> > > </formletter>
> > > 
> > > I'll not send this out for the other 6 patches that also do not 
> > > follow the proper format, as I'm sure you would get bored reading 
> > > them.
> > 
> > None of these patches exist upstream yet so it will take some time 
> > until any of this can touch -stable. You can ignore it safely for 
> > now.
> > 
> > Mike: please add proposed stable Cc: tags in the patch only, never 
> > send it out to the stable email address itself!!
> 
> Well, with the Cc: tag git-send-email will Cc it automatically if not
> done by the user explicitly.

And that's fine, I don't object to that at all, and it makes life easier
for me as I know it is coming eventually, and I try to watch out for it
in case the subsystem maintainer forgets to apply it.

It's when the Cc: in the signed-off-area is not there that my
form-letter kicks in to advise people that they are doing something
wrong and that their patch will not get applied to the stable tree this
way.

thanks,

greg k-h
