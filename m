Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab1FJVFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 17:05:19 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:39108 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758032Ab1FJVFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 17:05:00 -0400
X-Sasl-enc: R4SR3sFI8pVWK6HhtQuLcBfjFsr3qhpkFYlKvq1UY7MC 1307739899
Date: Fri, 10 Jun 2011 13:50:35 -0700
From: Greg KH <greg@kroah.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        hector@marcansoft.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: USB mini-summit at LinuxCon Vancouver
Message-ID: <20110610205035.GC13450@kroah.com>
References: <20110610002103.GA7169@xanatos>
 <20110610031805.GA15774@kroah.com>
 <20110610194815.GA6646@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110610194815.GA6646@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 12:48:15PM -0700, Sarah Sharp wrote:
> On Thu, Jun 09, 2011 at 08:18:05PM -0700, Greg KH wrote:
> > On Thu, Jun 09, 2011 at 05:21:03PM -0700, Sarah Sharp wrote:
> > > Topic 1
> > > -------
> > > 
> > > The KVM folks suggested that it would be good to get USB and
> > > virtualization developers together to talk about how to virtualize the
> > > xHCI host controller.  The xHCI spec architect worked closely with
> > > VMWare to get some extra goodies in the spec to help virtualization, and
> > > I'd like to see the other virtualization developers take advantage of
> > > that.  I'd also like us to hash out any issues they have been finding in
> > > the USB core or xHCI driver during the virtualization effort.
> > 
> > Do people really want to virtualize the whole xHCI controller, or just
> > specific ports or devices to the guest operating system?
> 
> A host OS could chose to virtualize the whole xHCI controller if it
> wanted to.  That's part of the reason why xHCI does all the bandwidth
> checking in hardware, not in software.

And here I thought it did that so it would be "correct" :)

> 
> > If just specific ports, would something like usbip be better for virtual
> > machines, with the USB traffic going over the network connection between
> > the guest/host?
> 
> It could be done that way too.  But that doesn't help if you're trying
> to run Windows under Linux, right?  Only if all the guest OSes use the
> same USB IP protocol then it would work.

usbip works on Windows as well as Linux.

But how could you run Windows with a xHCI controller in a guest, as
Windows has no xHCI driver?  What would it expect to see?

> > > Hope to see you there!
> > 
> > Thanks for putting this together.
> > 
> > Do we need to sign up somewhere to give the organizers a sense of how
> > many people will be attending?
> 
> I private ack by email would be great.  Or you can ack by facebook:
> https://www.facebook.com/event.php?eid=229532200405657  I could add the
> event in upcoming.yahoo.com if anyone uses that.

Nice try, but I'm still not going to join facebook...

