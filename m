Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1JMIoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 04:44:11 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:10691
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753574Ab1JMIoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:44:10 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-FB-SS: 13,
Subject: Re: [alsa-devel] [PATCH 2/9] ASoC: da7210: Add support for line
 input and mic
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20111012145310.GO3647@opensource.wolfsonmicro.com>
References: <1318431492.12107.403.camel@matrix>
	 <20111012145310.GO3647@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Oct 2011 14:25:38 +0530
Message-ID: <1318496138.12107.435.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-12 at 15:53 +0100, Mark Brown wrote:
> On Wed, Oct 12, 2011 at 08:28:12PM +0530, Ashish Chavan wrote:
> 
> > +static const char *da7210_mic_bias_voltage_txt[] = {
> > +	"1.5", "1.6", "2.2", "2.3"
> > +};
> > +
> > +static const struct soc_enum da7210_mic_bias =
> > +	SOC_ENUM_SINGLE(DA7210_MIC_L, 4, 4, da7210_mic_bias_voltage_txt);
> > +
> 
> This shouldn't be application controllable, it's a board property and if
> it needs to be managed it's likely to be by in kernel things like
> accessory detection.  We do have some older drivers that do this but
> they're not good.  Use platform data.
> 

In that case I think, it's better to remove it from here.


