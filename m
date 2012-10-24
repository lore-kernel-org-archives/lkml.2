Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab2JXPq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:46:26 -0400
Received: from 5.mo3.mail-out.ovh.net ([87.98.178.36]:41990 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750932Ab2JXPqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:46:24 -0400
Date: Wed, 24 Oct 2012 17:44:07 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: ludovic.desroches@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, voice.shen@atmel.com,
        marek.belisko@open-nandra.com, ivan.shugov@gmail.com,
        josh.wu@atmel.com
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH 0/8] at91: 3.7 fixes patch series
Message-ID: <20121024154407.GH18964@game.jcrosoft.org>
References: <cover.1351092432.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1351092432.git.nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 958140822856379244
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrtdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrtdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
On 17:33 Wed 24 Oct     , Nicolas Ferre wrote:
> 
> Hi all,
> I am posting this patch series just before sending a pull-request to Arnd and
> Olof.
> There are 2 new patches that I have just cooked today about external IRQ
> handling: please review.
> I would like you to double check that I have not made any mistake while
> collecting the other patches...
> 
> Thanks, best regards,
> 
> 
> Bo Shen (2):
>   ARM: at91/i2c: change id to let i2c-gpio work
>   ARM: at91/i2c: change id to let i2c-at91 work
> 
> Ivan Shugov (1):
>   ARM: at91: at91sam9g10: fix SOC type detection
> 
> Jean-Christophe PLAGNIOL-VILLARD (1):
>   ARM: at91: drop duplicated config SOC_AT91SAM9 entry
> 
> Josh Wu (1):
>   ARM: at91/tc: fix typo in the DT document
> 
> Marek Belisko (1):
>   ARM: at91/dts: at91sam9g20ek_common: Fix typos in buttons labels.
> 
> Nicolas Ferre (2):
>   ARM: at91: fix external interrupts in non-DT case
>   ARM: at91: fix external interrupt specification in board code
> 
>  Documentation/devicetree/bindings/arm/atmel-at91.txt |  2 +-
>  arch/arm/boot/dts/at91sam9g20ek_common.dtsi          |  4 ++--
>  arch/arm/mach-at91/Kconfig                           | 10 ++--------
>  arch/arm/mach-at91/at91rm9200.c                      |  2 +-
>  arch/arm/mach-at91/at91rm9200_devices.c              |  4 ++--
>  arch/arm/mach-at91/at91sam9260.c                     |  4 ++--
>  arch/arm/mach-at91/at91sam9260_devices.c             |  4 ++--
>  arch/arm/mach-at91/at91sam9261.c                     |  4 ++--
>  arch/arm/mach-at91/at91sam9261_devices.c             |  4 ++--
>  arch/arm/mach-at91/at91sam9263.c                     |  2 +-
>  arch/arm/mach-at91/at91sam9263_devices.c             |  4 ++--
>  arch/arm/mach-at91/at91sam9rl_devices.c              |  4 ++--
>  arch/arm/mach-at91/board-neocore926.c                |  2 +-
>  arch/arm/mach-at91/board-sam9261ek.c                 |  2 +-
>  arch/arm/mach-at91/board-sam9263ek.c                 |  2 +-
>  arch/arm/mach-at91/generic.h                         |  3 ++-
>  arch/arm/mach-at91/irq.c                             |  9 +++++++--
>  arch/arm/mach-at91/setup.c                           |  4 ++--
>  18 files changed, 35 insertions(+), 35 deletions(-)
> 
> -- 
> 1.7.11.3
> 
