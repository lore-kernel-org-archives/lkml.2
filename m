Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875Ab2GLN6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:58:48 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:41242 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab2GLN6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:58:46 -0400
X-IronPort-AV: E=Sophos;i="4.77,573,1336348800"; 
   d="scan'208";a="13504090"
Date: Thu, 12 Jul 2012 14:58:06 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ksummit-2012-discuss@lists.linux-foundation.org" 
	<ksummit-2012-discuss@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2012-discuss] ARM mini-summit
In-Reply-To: <061ef00be9b475973e5df22fcd096308@localhost>
Message-ID: <alpine.DEB.2.02.1207121432260.23783@kaball.uk.xensource.com>
References: <1341994155.3522.16.camel@dabdike.int.hansenpartnership.com> <20120711140536.GC16523@phenom.dumpdata.com> <CAPbh3rsnNNFNWEf651M-mO2UFOK8pFYTMV2x7RPhjHOAyf9OJw@mail.gmail.com> <201207112006.28632.arnd@arndb.de>
 <061ef00be9b475973e5df22fcd096308@localhost>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012, Marc Zyngier wrote:
> On Wed, 11 Jul 2012 20:06:28 +0000, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 11 July 2012, Konrad Rzeszutek Wilk wrote:
> >> >> > contacts, with Grant and Olof joining in as time permits.
> >> >>
> >> >> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> >> >
> >> > I would be interested in attending it as well. I believe Stefano has
> a
> >> > strong
> >> > interest as well (since he and Ian Campbell are leading the Xen ARM
> >> > work).
> >> 
> >> And Stefano is out on vacation right now so I will serve as his phantom
> >> voice
> >> and say: "Yes, I am interested as well."
> > 
> > Ok. So are you mostly interested in discussion ARM virtualization or
> other
> > topics
> > as well? Last time we had organized this explicitly as the "ARM subarch
> > maintainer
> > summit" and we might again limit the participants to the subarch
> > maintainers and
> > a few more people if we're running out of space, but then again if a lot
> > of them
> > are interested in discussion virtualization, we should probably have you
> > both and 
> > the ARM KVM people included as well.
> > 
> > We haven't even started discussing an agenda, but I'll note down your
> > names as
> > candidates and Xen and/or KVM as proposed topics. I'll follow up with a
> > more
> > formal call for topics once I have a positive confirmation from James
> and
> > the
> > linux-foundation that we can go ahead with the ARM mini-summit.
> 
> Putting on my KVM/ARM hacker hat this time: I'd be very glad to contribute
> to the discussion. There is a number of ARM-specific topics that would be
> interesting to discuss regarding KVM/ARM (mainlining the damn thing, common
> hypercalls?, HYP mode booting), and probably a couple of other things.


That's right: the hypercall calling convention, notifications from the
hypervisor via GIC, the boot process and device tree for virtual
hardware are all interesting topics to discuss.
