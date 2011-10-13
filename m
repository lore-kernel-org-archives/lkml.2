Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1JMImK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 04:42:10 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:52797
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753574Ab1JMImI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:42:08 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: [alsa-devel] [PATCH 1/9] ASoC: da7210: Add support for line
 out and DAC
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        <kuninori.morimoto.gx@renesas.com>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20111012144940.GN3647@opensource.wolfsonmicro.com>
References: <1318431375.12107.398.camel@matrix>
	 <20111012144940.GN3647@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Oct 2011 14:23:34 +0530
Message-ID: <1318496015.12107.434.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-12 at 15:49 +0100, Mark Brown wrote:
> On Wed, Oct 12, 2011 at 08:26:15PM +0530, Ashish Chavan wrote:
> 
> > +	SOC_DOUBLE_R_TLV("DAC Playback Volume",
> > +			 DA7210_DAC_L, DA7210_DAC_R,
> > +			 0, 0x77, 1, dac_gain_tlv),
> 
> Digital Playback Volume.

OK, will update it.

> 
> > +	/* Set default DAC gain */
> > +	snd_soc_write(codec, DA7210_DAC_L, DA7210_DFLT_DAC_GAIN);
> > +	snd_soc_write(codec, DA7210_DAC_R, DA7210_DFLT_DAC_GAIN);
> 
> No, use chip defaults.
> 

I see.


