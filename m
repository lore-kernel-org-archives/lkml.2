Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab1KLAvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 19:51:13 -0500
Received: from sous-sol.org ([216.99.217.87]:57655 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754890Ab1KLAvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 19:51:11 -0500
Date: Fri, 11 Nov 2011 16:51:00 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Roland Dreier <roland@purestorage.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, chrisw@sous-sol.org, ddutile@redhat.com
Subject: Re: [PATCH] intel-iommu: Default to non-coherent for domains
 unattached to iommus
Message-ID: <20111112005100.GR14486@sequoia.sous-sol.org>
References: <20111111224849.9756.13368.stgit@bling.home>
 <1321058267.2006.21.camel@shinybook.infradead.org>
 <CAL1RGDXZjKhA++3eFVPbazixaM7Q_JfBJyLKE0xjBs+sK55idg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1RGDXZjKhA++3eFVPbazixaM7Q_JfBJyLKE0xjBs+sK55idg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roland Dreier (roland@purestorage.com) wrote:
> On Fri, Nov 11, 2011 at 4:37 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> > This brain-damage only affects the first chipsets
> > from before we worked out that cache incoherency was a *really* f*cking
> > stupid idea, doesn't it?
> 
> As we talked about at KS, I have some Westmere EP (ie latest
> and greatest server platform) systems where the BIOS exposes
> an option that allows choosing VT-d coherency on or off, and
> defaults it to "off".

That's just more brain damage AFAICT.  Esp. if you do performance
testing (and choose not to use passthrough mode)... have and it's
quite measurable.  I switched default to on long time ago, w/out
issue.

> What is the "official" Intel line on coherency with Westmere and
> Tylersburg -- because as I also mentioned, I was seeing some
> problems with VT-d and the default "coherency off" setting that
> looked like the IOMMU HW is getting stale PTEs (ie a missing
> or not working cache flush).

That sounds like sw bugs more than official recommendation issue.

thanks,
-chris
