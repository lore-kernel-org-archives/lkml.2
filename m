Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab2KZLmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:42:03 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56509 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab2KZLmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:42:01 -0500
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>
CC: "tony@atomide.com" <tony@atomide.com>, "Girdwood, Liam" <lrg@ti.com>,
        "perex@perex.cz" <perex@perex.cz>, "Nori, Sekhar" <nsekhar@ti.com>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 0/2] ARM/ASoC: Davinci: Device Tree Update
Thread-Topic: [PATCH 0/2] ARM/ASoC: Davinci: Device Tree Update
Thread-Index: AQHNyGaROfTe34APuU+r7qT3nr+lEJf8Awbw
Date: Mon, 26 Nov 2012 11:41:43 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EAD78D4@DBDE01.ent.ti.com>
References: <1353557099-21599-1-git-send-email-gururaja.hebbar@ti.com>
In-Reply-To: <1353557099-21599-1-git-send-email-gururaja.hebbar@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Thu, Nov 22, 2012 at 09:34:57, Hebbar, Gururaja wrote:
> From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
> 
> 1. Add pinctrl for McASP Module
> 2. Add DT support for Davinci machine platform (resend)
> 
> Second commit is a resend after re-basing on latest broonie-asoc/for-next
> (v3.7-rc6)
> 
> Hebbar, Gururaja (2):
>   ASoC: davinci-mcasp: Add pinctrl support
>   ASoC: Davinci: machine: Add device tree binding

With these 2 patches, DT support for Davinci ASoC will be complete 
(well almost because edma dt binding is yet to be added). 
However it will at least be complete on Davinci platform.

Can you please review them and if it's OK, Could you please accept this series?

> 
>  .../bindings/sound/davinci-evm-audio.txt           |   66 +++++++
>  sound/soc/davinci/davinci-evm.c                    |  185 +++++++++++++++++---
>  sound/soc/davinci/davinci-mcasp.c                  |    7 +
>  3 files changed, 238 insertions(+), 20 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/sound/davinci-evm-audio.txt
> 
> -- 
> 1.7.9.5
> 
> 


Regards, 
Gururaja
