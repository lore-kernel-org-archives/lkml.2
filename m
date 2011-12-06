Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1LFHfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 02:35:18 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:19181
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156Ab1LFHfQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 02:35:16 -0500
X-SpamScore: -17
X-BigFish: VS-17(zz9371K542M1432N98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Guo Shawn-R65073 <r65073@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: RE: [RFC PATCH 1/3] pinctrl: imx: add pinmux imx core driver
Thread-Topic: [RFC PATCH 1/3] pinctrl: imx: add pinmux imx core driver
Thread-Index: AQHMsnlAdrguC9Qi5Ei/Yb1CNiu/O5XO0+qA//+Z0UA=
Date: Tue, 6 Dec 2011 07:35:12 +0000
Message-ID: <65EE16ACC360FA4D99C96DC085B3F772345A4D@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
 <20111206073908.GC3712@S2100-06.ap.freescale.net>
In-Reply-To: <20111206073908.GC3712@S2100-06.ap.freescale.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.89]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Guo Shawn-R65073
> Sent: Tuesday, December 06, 2011 3:39 PM
> To: Dong Aisheng-B29396
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> linus.walleij@stericsson.com; s.hauer@pengutronix.de;
> kernel@pengutronix.de
> Subject: Re: [RFC PATCH 1/3] pinctrl: imx: add pinmux imx core driver
> 
> On Sun, Dec 04, 2011 at 07:49:42PM +0800, Dong Aisheng wrote:
> > +static struct platform_device_id imx_pinctrl_devtype[] = {
> > +	{
> > +		.name = "sdhci-pinctrl-imx53",
> > +		.driver_data = (kernel_ulong_t)&mx53_pinctrl_info,
> > +	}, {
> > +		.name = "sdhci-pinctrl-imx6q",
> > +		.driver_data = (kernel_ulong_t)&mx6q_pinctrl_info,
> > +	},
> > +};
> 
> The platform_device_id table needs an empty entry to be the sentinel.
> 
Acked.

Regards
Dong Aisheng

