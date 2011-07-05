Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1GEJ2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 05:28:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54634 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab1GEJ2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 05:28:30 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "Girdwood, Liam" <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: Re: Re: [PATCH v6 08/18] mfd: twl6040: Add initial support
Date: Tue, 5 Jul 2011 12:28:17 +0300
Message-ID: <2205166.k2KJlqZUA7@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110704173935.GT3021@sortiz-mobl>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com> <1650114.SY7VdjHPHs@barack> <20110704173935.GT3021@sortiz-mobl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Monday 04 July 2011 19:39:35 Samuel Ortiz wrote:
> That is fine with me, yes. That's why I ACK the MFD patches for Tony to take
> them.

I have changed the series for Tony in my branch for the following comments:
wl6040_is_powered, twl6040_get_rev removal, since these are really small 
changes, if you want to see it before Tony pulls it, I can send the selected 
patches (few lines has been changed).

> Thanks in advance for the follow up patches.

For the twl6040_*_irq changes, I sent the series, since I ended up with a 
bigger change than I would have expected.

Regards, 
Péter
