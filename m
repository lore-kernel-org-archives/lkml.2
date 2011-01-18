Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab1ARVsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:48:32 -0500
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:34174 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813Ab1ARVsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:48:31 -0500
Subject: Re: [PATCH] pxa3xx: fix PXA GPIO IRQ handling
From: Sven Neumann <s.neumann@raumfeld.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Lennert Buijtenhek <buytenh@wantstofly.org>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@caiaq.de>
In-Reply-To: <AANLkTi=gGDZHukdSuupg22Gb9te+Vk_rsu6-vREeQRVE@mail.gmail.com>
References: <1295338561.2003.3.camel@sven>
	 <1295338738-4129-1-git-send-email-s.neumann@raumfeld.com>
	 <4D357DC0.2030006@metafoo.de>
	 <AANLkTi=gGDZHukdSuupg22Gb9te+Vk_rsu6-vREeQRVE@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: RAUMFELD GmbH
Date: Tue, 18 Jan 2011 22:49:07 +0100
Message-ID: <1295387347.20633.3.camel@bender>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;s.neumann@raumfeld.com;1295387311;7afec5ce;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 08:15 -0800, Eric Miao wrote:
> On Tue, Jan 18, 2011 at 3:47 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> > On 01/18/2011 09:18 AM, Sven Neumann wrote:
> >> From: Lars-Peter Clausen <lars@metafoo.de>
> >>
> >> Set the "set_wake" field of the irq_chip struct before calling
> >> set_irq_chip() for all of the IRQs, so that the compat handler
> >> actually gets installed.
> 
> Not really sure if this is necessary. Lennert has done the transition to
> irq_data to those _set_wake() functions as well, so it should be OK
> that compat handler doesn't get installed.
> 
> Now I'm not against moving this above, just wondering if there were
> any consequences/errors coming out?

Well, our PXA300 device doesn't power up again when it should resume
from suspend. Fine with me if this has been fixed upstream, but I would
still like to get this patch into 2.6.37. I'll try to test upstream as
soon as Linus releases 2.6.38-rc1...


Sven


