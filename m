Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab1JKT5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 15:57:14 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60660 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932065Ab1JKT5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 15:57:12 -0400
X-Sasl-enc: pfnjs54RBx7MmuUMZNfhNLWp4/KZPYpqnRV9/JfjN6LJ 1318363031
Date: Tue, 11 Oct 2011 13:56:11 -0600
From: Greg KH <greg@kroah.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [01/38] PCI: Set PCI-E Max Payload Size on fabric
Message-ID: <20111011195611.GA2956@kroah.com>
References: <20111011165903.GA30976@kroah.com>
 <20111011165708.466042477@pistachio.kroah.org>
 <20111011172019.GI10838@kvack.org>
 <CAErSpo6JFTm4y35Nz7aNUgM3ynX52fM1-AwX7OTOwm3cminv1Q@mail.gmail.com>
 <20111011192447.GC1112@kroah.com>
 <CAErSpo47Yw3Vygs5=OVmtUuLsB9FxJeYBm20UYem-Z3L7B0UhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo47Yw3Vygs5=OVmtUuLsB9FxJeYBm20UYem-Z3L7B0UhQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 01:47:47PM -0600, Bjorn Helgaas wrote:
> On Tue, Oct 11, 2011 at 1:24 PM, Greg KH <greg@kroah.com> wrote:
> > On Tue, Oct 11, 2011 at 12:14:05PM -0600, Bjorn Helgaas wrote:
> 
> >> It's not obvious that this fits the criteria for -stable
> >> (Documentation/stable_kernel_rules.txt).
> >>
> >> For example, I can't tell what real problem this fixes.
> >
> > Yeah, it's not obvious, but I have had a lot of reports that 3.0 does
> > not work on some systems without this set of patches.  Now figuring out
> > of those same systems ever worked at all is getting to be quite
> > difficult as I don't have access to the hardware, and the people that do
> > aren't responding to test requests.  But from what I gather, 2.6.32 did
> > work on these boxes, so it is a regression somehow, but I am not
> > positive of this.
> 
> I'd like to know more about this regression.

It shows up as an oops that prevents the machine from booting.

> > Now I'm very open to pushback, and if people really don't want these in
> > (i.e. the PCI maintainer(s) say no), then I'll drop them and work with
> > the distros to get them into their trees so that their customers's
> > systems will work properly.
> 
> If distros want these patches, does that mean they have bug reports?
> URLs to them would be helpful.

All of the ones I have are "private" at the moment due to the hardware
and product being tested by the users, sorry.

I really wish that some of the people who had this problem would post
publically, and I guess we could just say, because they aren't being
public about it, it shouldn't go into a stable tree.  And I don't have a
problem with that.

> I just haven't seen any concrete information that says -stable will be
> better off if it includes these patches.  We've tripped over enough
> problems upstream that I'm concerned they might make things worse
> rather than better.

Even though it is disabled by default?

thanks,

greg k-h
