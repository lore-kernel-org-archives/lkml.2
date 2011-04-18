Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab1DRQ2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:28:08 -0400
Received: from relais.videotron.ca ([24.201.245.36]:21669 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab1DRQ2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:28:00 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 18 Apr 2011 12:27:59 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Sean Young <sean@mess.org>
Cc: Robin Becker <robin@reportlab.com>, Peter Korsgaard <jacmet@sunsite.dk>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: arm: mach-kirkwood: Make the red led available on the eSATA
 SheevaPlug
In-reply-to: <20110418113640.GA11559@pequod.mess.org>
Message-id: <alpine.LFD.2.00.1104181218270.24613@xanadu.home>
References: <20110416220842.GA1518@pequod.mess.org>
 <4DAC0390.9050205@chamonix.reportlab.co.uk>
 <20110418113640.GA11559@pequod.mess.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011, Sean Young wrote:

> On Mon, Apr 18, 2011 at 10:25:36AM +0100, Robin Becker wrote:
> > On 16/04/2011 23:08, Sean Young wrote:
> > >After this patch:
> > >
> > >         7780c80 arm: mach-kirkwood: add led in sheevaplug-setup.c
> > >
> > >On a eSATA SheevaPlug, neither the red nor the green led can be controlled,
> > >since probing fails with:
> > >
> > >[    6.188278] leds-gpio: probe of leds-gpio failed with error -22
> > >
> > >Signed-off-by: Sean Young<sean@mess.org>
[...]
> > I think my original patch had some changes to gpio_led
> > sheevaplug_led_pins as well. 
> 
> Yes, which causes breakage on my eSATA SheevaPlug without my patch above,
> since the corresponding GPIO pins aren't enabled.

I didn't closely follow the matter, so could both of you resolve 
possible issues and resent me the appropriate patch with Acked-by tags 
please?


Nicolas
