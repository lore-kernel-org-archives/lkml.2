Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab2L0QrC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 11:47:02 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:38448 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab2L0QrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 11:47:00 -0500
Subject: Re: What does ISA/PCI really mean to ARM architecture?
From: anish kumar <anish198519851985@gmail.com>
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Cc: Woody Wu <narkewoody@gmail.com>, kernelnewbies@kernelnewbies.org,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <CAKON4OwtPJYRp=FevsX5NLzohX=iLxf2FS0dG4hmdpcGayBy8Q@mail.gmail.com>
References: <20121227082724.GA11775@zuhnb712.ap.bm.net>
	 <CAKON4OwtPJYRp=FevsX5NLzohX=iLxf2FS0dG4hmdpcGayBy8Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Dec 2012 22:16:42 +0530
Message-ID: <1356626802.5433.34.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-27 at 11:22 -0500, jonsmirl@gmail.com wrote:
> On Thu, Dec 27, 2012 at 3:27 AM, Woody Wu <narkewoody@gmail.com> wrote:
> > Hi, list
> >
> > I know this might be a very basic question.  But I really don't clear at
> > it.
> >
> > Can a peripheral chip that claims to be ISA or PCI device be used in a
> > ARM based embedded system?  For these kind of chips, I only concern
> > about the planar kind of devices, means they are not on a dedicated
> > expansion card.
> >
> > From hardware point of view, to attach a ISA or PCI planar chip, is
> > there any requirement need to fulfill on a ARM board?
> 
> See if your ARM CPU has an interface for SRAM (in addition to DRAM).
> You can use a SRAM chip select to access ISA type devices. But you may
Would you mind explaining this in detail?
> need additional buffers/latches to do this.
> 
> Another solution is to attach you peripherals using USB. Almost all
Connect using USB what does this mean?
> embedded wifi chips are attached this way. The USB connectors aren't
> required, you can route USB around on your PCB. USB hub chips are
> $0.35 if you need more ports.  USB Ethernet chips are available.
> 
> Other options include SPI/I2C. It is worthwhile to investigate these
Only chips which support SPI/I2C can be used but ISA/PCI is completely
orthogonal to this AFAIK.
> serial solutions before doing a parallel solution. Parallel buses eat
> up a lot of PCB space.
> 
> 
> >
> > From Linux driver point of view, what are needed to support an ISA or
> > PCI driver in ARM architecture?  More important, is ISA or PCI device a
> > platform device?  If not, how to add these kind of devices in my board
> > definition?
> >
> > I know my question might not be reasonable enough, if I messed concepts,
> > please sort me out.
> >
> >
> > Thanks in advance.
> >
> >
> > --
> > woody
> > I can't go back to yesterday - because I was a different person then.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
> --
> Jon Smirl
> jonsmirl@gmail.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


