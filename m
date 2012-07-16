Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab2GPI2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 04:28:20 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:60708 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752663Ab2GPI2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:28:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120716081204.GI7955@arwen.pp.htv.fi>
References: <1340370942-23201-1-git-send-email-kishon@ti.com>
	<CAAe_U6+dkiQw-i93pFapt6qKrArzaQoE8X3GjDzUDraziG8B2Q@mail.gmail.com>
	<20120625122449.GA30463@arwen.pp.htv.fi>
	<201206251626.09666.arnd@arndb.de>
	<20120716081204.GI7955@arwen.pp.htv.fi>
Date: Mon, 16 Jul 2012 13:58:14 +0530
Message-ID: <CAAe_U6JMGP3jEkkd=vqpR5KTeOnY51AOcb65zqKRRa8MtnWjzQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/2] drivers: misc: omap: add a new driver for ocp2scp
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: balbi@ti.com
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, b-cousson@ti.com, rnayak@ti.com,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 16, 2012 at 1:42 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Jun 25, 2012 at 04:26:08PM +0000, Arnd Bergmann wrote:
>> On Monday 25 June 2012, Felipe Balbi wrote:
>> > > > Can't this live where the scp drivers live?  Actually, where is that at?
>> > > > Do we have scp drivers?
>> > > AFAIK, there isn't any driver for scp. But we have a driver for ocp
>> > > and it is present at arch/arm/mach-omap2/omap_l3_noc.c
>> >
>> > I don't think this deserves a directory of its own. Maybe
>> > drivers/platform/arm/omap/ ?? the l3_noc is an OMAP-specific
>> > interconnect and the SCP bus is also an OMAP-specific bus. I don't know
>> > of any other arch/soc who uses the same interconnect IP as OMAP and the
>> > same ocp2scp bridge. That bridge was created by TI for all I know.
>> >
>> > Greg, would drivers/platform/arm/omap/ work for you ? We could also move
>> > the interconnect drivers there.
>>
>> I really don't like the idea of introducing drivers/platform/arm/ because
>> very little of the stuff that one would put in there are actually ARM
>> specific.
>>
>> I have suggested a drivers/bus/ before and people did not see the need
>> back then, and we agreed to continue having a directory for each bus,
>> as we have for the big ones (pci, usb, i2c, spi, ...) and a lot of
>> simple (amba, rapidio, bcma, ...) or obscure (tc,  vlynq, nubus, ...)
>> ones.
>>
>> I think we should reconsider the idea of drivers/bus/ with a file per
>> bus in there at least for new buses, but doing a new drivers/scp/
>> would be ok for me if there is enough opposition against the idea
>> of drivers/bus aggregating different buses.
>
> I don't mind either way. The fact is that this ocp-to-scp bridge is
> really a TI/OMAP thing. Not sure it deserves a directory of its own.

Ok. Then I'll have a file in drivers/bus/ for ocp2scp driver.

Thanks
Kishon
