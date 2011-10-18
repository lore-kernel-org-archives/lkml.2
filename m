Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab1JRLsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 07:48:01 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:37542 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754132Ab1JRLr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 07:47:59 -0400
X-SpamScore: -13
X-BigFish: VS-13(zz1dbaL1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 18 Oct 2011 19:58:37 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rajendra Nayak <rnayak@ti.com>
CC: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <patches@linaro.org>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <lrg@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111018115836.GC30703@S2100-06.ap.freescale.net>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
 <1318263578-7407-4-git-send-email-rnayak@ti.com>
 <20111016145536.GA29885@S2100-06.ap.freescale.net>
 <4E9BAC4D.3010402@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E9BAC4D.3010402@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 09:47:17AM +0530, Rajendra Nayak wrote:
> 
> >I do not see that of_get_regulation_constraints() covers the following
> >fields.  We do not support them for DT probe?
> 
> I left these out as I wasn't sure how such (if at all) Linux
> specific params should be passed through dt, and I am still not
> quite sure :(
> 
I'm seeing some linux specific parameters encoded in the device tree
below.

  Documentation/devicetree/bindings/gpio/gpio_keys.txt
  Documentation/devicetree/bindings/gpio/led.txt

Mark,

I understand that ideally device tree is supposed to describe pure
hardware configurations.  But practically, when migrating a driver
to device tree probe, we are trying to move the configurations
described by platform_data into device tree to save the use of
platform_data for device tree probe.  Then some of the configuration
may not be so purely hardware related.  But I do not see this is a
critical problem.

What do you think?  Is it what you want that we classify the
configurations clearly and put only strict hardware configurations
into device tree and keep others still in platform_data?

-- 
Regards,
Shawn

