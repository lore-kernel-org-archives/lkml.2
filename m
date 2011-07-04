Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab1GDNJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 09:09:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37726 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009Ab1GDNJc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 09:09:32 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>
CC: "Girdwood, Liam" <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: Re: [PATCH v6 08/18] mfd: twl6040: Add initial support
Date: Mon, 4 Jul 2011 16:09:30 +0300
Message-ID: <4014234.U3Af1Vqyz9@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110704125330.GI2820@legolas.emea.dhcp.ti.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com> <1308663556-29120-9-git-send-email-peter.ujfalusi@ti.com> <20110704125330.GI2820@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe, Samuel,

On Monday 04 July 2011 14:53:30 Balbi, Felipe wrote:
> > +		ret = twl6040_request_irq(twl6040, TWL6040_IRQ_READY,
> > +					  twl6040_naudint_handler, 0,
> > +					  "twl6040_irq_ready", twl6040);
> 
> why don't you use the normal request_threaded_irq() ?? This is a bit of
> obfuscation IMO.

I have left this 'macro' in since it is also used within the twl6040-vibra, 
and twl6040 ASoC codec driver to request the irq for them.
But if you think it is better to replace the twl6040_request_irq with direct 
request_threaded_irq in those drivers as well, I'll do that.

-- 
Péter
