Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab1JKVez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 17:34:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab1JKVej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 17:34:39 -0400
Date: Tue, 11 Oct 2011 15:32:04 -0600
From: Greg KH <gregkh@suse.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Greg KH <greg@kroah.com>, Benjamin LaHaise <bcrl@kvack.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [01/38] PCI: Set PCI-E Max Payload Size on fabric
Message-ID: <20111011213204.GB3881@suse.de>
References: <20111011165903.GA30976@kroah.com>
 <20111011165708.466042477@pistachio.kroah.org>
 <20111011172019.GI10838@kvack.org>
 <CAErSpo6JFTm4y35Nz7aNUgM3ynX52fM1-AwX7OTOwm3cminv1Q@mail.gmail.com>
 <20111011192447.GC1112@kroah.com>
 <CAErSpo47Yw3Vygs5=OVmtUuLsB9FxJeYBm20UYem-Z3L7B0UhQ@mail.gmail.com>
 <20111011195611.GA2956@kroah.com>
 <CAErSpo7pVC2DxVDmE-oJm6KmaVbWKi2OdCiSastoGQdfMgg+Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo7pVC2DxVDmE-oJm6KmaVbWKi2OdCiSastoGQdfMgg+Kg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 02:22:11PM -0600, Bjorn Helgaas wrote:
> On Tue, Oct 11, 2011 at 1:56 PM, Greg KH <greg@kroah.com> wrote:
> > On Tue, Oct 11, 2011 at 01:47:47PM -0600, Bjorn Helgaas wrote:
> >> On Tue, Oct 11, 2011 at 1:24 PM, Greg KH <greg@kroah.com> wrote:
> >> > On Tue, Oct 11, 2011 at 12:14:05PM -0600, Bjorn Helgaas wrote:
> >>
> >> >> It's not obvious that this fits the criteria for -stable
> >> >> (Documentation/stable_kernel_rules.txt).
> >> >>
> >> >> For example, I can't tell what real problem this fixes.
> >> >
> >> > Yeah, it's not obvious, but I have had a lot of reports that 3.0 does
> >> > not work on some systems without this set of patches.  Now figuring out
> >> > of those same systems ever worked at all is getting to be quite
> >> > difficult as I don't have access to the hardware, and the people that do
> >> > aren't responding to test requests.  But from what I gather, 2.6.32 did
> >> > work on these boxes, so it is a regression somehow, but I am not
> >> > positive of this.
> >>
> >> I'd like to know more about this regression.
> >
> > It shows up as an oops that prevents the machine from booting.
> >
> >> > Now I'm very open to pushback, and if people really don't want these in
> >> > (i.e. the PCI maintainer(s) say no), then I'll drop them and work with
> >> > the distros to get them into their trees so that their customers's
> >> > systems will work properly.
> >>
> >> If distros want these patches, does that mean they have bug reports?
> >> URLs to them would be helpful.
> >
> > All of the ones I have are "private" at the moment due to the hardware
> > and product being tested by the users, sorry.
> >
> > I really wish that some of the people who had this problem would post
> > publically, and I guess we could just say, because they aren't being
> > public about it, it shouldn't go into a stable tree.  And I don't have a
> > problem with that.
> 
> I think accepting patches without our having a chance to see the
> problem sets a bad precedent.  It's quite common to see patches that
> "solve" the problem, but do it in the wrong way.
> 
> If the hardware is secret, maybe they could open a new, sanitized bug
> report?  It should be easy to remove the valuable details from the
> dmesg log and oops.

I'll go ask again for them to do this, and I'll drop these patches from
the release.

thanks,

greg k-h
