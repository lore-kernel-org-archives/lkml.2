Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1LOHg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:36:27 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:23132
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752167Ab1LOHg0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:36:26 -0500
X-SpamScore: -12
X-BigFish: VS-12(zcb8kz9371I542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: RE: [RFC PATCH v2 3/4] ARM: imx6q: using pinmux subsystem
Thread-Topic: [RFC PATCH v2 3/4] ARM: imx6q: using pinmux subsystem
Thread-Index: AQHMunjdgt9kWQ/m90io45LHpUq5BJXcBMkAgAB+b/A=
Date: Thu, 15 Dec 2011 07:36:23 +0000
Message-ID: <7FE21149F4667147B645348EC6057885056286@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
	<1323878622-26602-4-git-send-email-b29396@freescale.com>
 <CACRpkdZhj2cqPL4yt+Xg7vy4jg-eauNzZFBUw2aSfvAauTqP0A@mail.gmail.com>
In-Reply-To: <CACRpkdZhj2cqPL4yt+Xg7vy4jg-eauNzZFBUw2aSfvAauTqP0A@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.198]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Linus Walleij [mailto:linus.walleij@linaro.org]
> Sent: Thursday, December 15, 2011 2:03 AM
> To: Dong Aisheng-B29396
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> linus.walleij@stericsson.com; s.hauer@pengutronix.de; Guo Shawn-R65073;
> kernel@pengutronix.de; grant.likely@secretlab.ca; rob.herring@calxeda.com
> Subject: Re: [RFC PATCH v2 3/4] ARM: imx6q: using pinmux subsystem
> Importance: High
> 
> On Wed, Dec 14, 2011 at 5:03 PM, Dong Aisheng <b29396@freescale.com>
> wrote:
> 
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> >
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > Cc: Shawn Guo <shanw.guo@freescale.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> > +static struct pinmux_map imx6q_pinmux_map[] = {
> > +       PINMUX_MAP_PRIMARY("usdhc4", "sd4", "219c000.usdhc"), };
> > +
> >  static void __init imx6q_init_machine(void)
> >  {
> >        of_platform_populate(NULL, of_default_bus_match_table, NULL,
> > NULL);
> > -
> > +       pinmux_register_mappings(imx6q_pinmux_map,
> > +                                ARRAY_SIZE(imx6q_pinmux_map));
> >        imx6q_pm_init();
> >  }
> 
> So ideally this bit of code should also go into the device tree and we
> should add a DT hook inside drivers/pinctrl/pinmux.c
> 
> Please make a patch for this if you have a clear idea on how it should
> work!
> 
Yes, I will try to see that and will discuss with you once got an idea.

Regards
Dong Aisheng

