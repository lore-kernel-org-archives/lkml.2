Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab1BVUAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:00:38 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55692 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab1BVUAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:00:37 -0500
Date: Tue, 22 Feb 2011 14:47:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>, abogani@texware.it
Subject: Re: [PATCH] rt2x00: Use ops name instead of device name
Message-ID: <20110222194724.GG12153@tuxdriver.com>
References: <1298380368.6140.1193.camel@gandalf.stny.rr.com>
 <1298381695.2211.486.camel@localhost>
 <1298382263.6140.1196.camel@gandalf.stny.rr.com>
 <AANLkTinNUnq7JQDpTzCv24A7T7fMn9iPFisQEBZGkELr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinNUnq7JQDpTzCv24A7T7fMn9iPFisQEBZGkELr@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 08:33:45PM +0100, Ivo Van Doorn wrote:
> Hi,
> 
> On Tue, Feb 22, 2011 at 2:44 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Tue, 2011-02-22 at 13:34 +0000, Ben Hutchings wrote:
> >
> >> > 19:   73474106          0   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb6, 0000:05:01.0
> >
> >> >     rt2x00dev->irq = pci_dev->irq;
> >> > -   rt2x00dev->name = pci_name(pci_dev);
> >> > +   rt2x00dev->name = ops->name;
> >
> >
> >> But then how can users distinguish the IRQs for multiple devices handled
> >> by the same driver?  (Probably unusual for WLAN devices, but still
> >> possible.)
> >>
> >> I assume you can't use a net device name as there may be multiple net
> >> devices per bus device?
> >
> > Honestly, I do not know this code well enough, but this patch seemed to
> > solve the problem at hand. Hence I sent it out to the experts hoping
> > they either take this patch or come up with a proper solution ;)
> >
> > In any case, just posting the pci address is not a pretty answer.
> 
> I just checked the other wireless drivers, and they all seem to use
> the modulename. So I guess your patch is correct. You can add my:
> 
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

I completely missed this series -- please be sure to Cc:
linux-wireless@vger.kernel.org if you resend, and/or resend the series
directly to me?

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
