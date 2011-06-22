Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab1FVMkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 08:40:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45198 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab1FVMkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 08:40:12 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: Re: [PATCH v6 15/18] ASoC: twl6040: Remove pll and headset mode dependency
Date: Wed, 22 Jun 2011 14:39:46 +0300
Message-ID: <9947082.diNasC8ni8@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110621173505.GC26592@opensource.wolfsonmicro.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com> <1308663556-29120-16-git-send-email-peter.ujfalusi@ti.com> <20110621173505.GC26592@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On Tuesday 21 June 2011 19:35:05 Mark Brown wrote:
> On Tue, Jun 21, 2011 at 04:39:13PM +0300, Peter Ujfalusi wrote:
> > From: Misael Lopez Cruz <misael.lopez@ti.com>
> > 
> > Remove dependency between pll (hppll, lppll) and headset power
> > mode (low-power, high-performance), as headset power mode can
> > be used with any pll.
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> but you should note that the code has been modified since Misael's
> original version.

Oh.
I did intended to put comments related to the changes has been done to this 
patch. Obviously I forgot to do that.
I did not added your ack to this patch, since I knew that I have changed a bit 
more.
Sorry.

-- 
Péter
