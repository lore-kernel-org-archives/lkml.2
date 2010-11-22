Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab0KVQFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:05:06 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:48478
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992Ab0KVQFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:05:04 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzz8275bhz2dh2a8h637h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw01.freescale.net;RD:az33egw01.freescale.net;EFVD:NLI
Message-ID: <4CEA9495.8040605@freescale.com>
Date: Mon, 22 Nov 2010 10:04:37 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101101 Fedora/2.0.10-1.fc13 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Lars-Peter Clausen <lars@metafoo.de>, <alsa-devel@alsa-project.org>,
        Jarkko Nikula <jhnikula@gmail.com>
Subject: Re: [PATCH v2] ASoC: atmel: test wrong variable
References: <1290361216-15166-1-git-send-email-segoon@openwall.com> <20101122094353.f76830b5.jhnikula@gmail.com> <20101122155913.GA9089@albatros>
In-Reply-To: <20101122155913.GA9089@albatros>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Nov 2010 16:05:45.0644 (UTC) FILETIME=[1EFA56C0:01CB8A5F]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasiliy Kulikov wrote:
> After clk_get() mclk is checked second time instead of pllb check.
> In patch v1 Jarkko Nikula noticed that PTR_ERR() is also has wrong argument.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Why am I'm being cc'd on Atmel driver patches?  I've done no work on these drivers.

-- 
Timur Tabi
Linux kernel developer at Freescale

