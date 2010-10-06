Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab0JFDra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 23:47:30 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:50321 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756872Ab0JFDr3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 23:47:29 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: "lars@metafoo.de" <lars@metafoo.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "philipp.zabel@gmail.com" <philipp.zabel@gmail.com>,
        "robert.jarzmik@free.fr" <robert.jarzmik@free.fr>,
        "marek.vasut@gmail.com" <marek.vasut@gmail.com>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        "bgat@billgatliff.com" <bgat@billgatliff.com>
Date: Wed, 6 Oct 2010 05:46:02 +0200
Subject: RE: [PATCHv2 0/7] PWM core driver for pwm based led and backlight
 driver
Thread-Topic: [PATCHv2 0/7] PWM core driver for pwm based led and backlight
 driver
Thread-Index: Actknrb4TxfICNkPRv+PuXsOPvAcIQAaZA9w
Message-ID: <F45880696056844FA6A73F415B568C6953571D4EFD@EXDCVYMBSTM006.EQ1STM.local>
References: <1286280002-1636-1-git-send-email-arun.murthy@stericsson.com>
 <87wrpwu1cw.fsf@deeprootsystems.com>
In-Reply-To: <87wrpwu1cw.fsf@deeprootsystems.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Arun Murthy <arun.murthy@stericsson.com> writes:
> 
> > PWM core driver for pwm based led and backlight driver.
> > The intention of the pwm core driver is not to break the build if two
> or more
> > pwm drivers are enabled.
> > Align the existing pwm drivers to make use of the pwm core driver
> 
> Hi Arun,
> 
> Because you have Bill Gatliff on Cc, I'm guessing you've already looked
> at his RFC for a generic PWM framework?
> 
> There's recently been a proposal on DaVinci that is similar to yours
> that enables multiple PWM drivers, but it would be nice to have a
> common
> framework for this, and what Bill has proposed seems to be a good
> solution.
> 
Thanks for the information. This patch set of implementing pwm core driver
is aligned with the one in Davinci. Davinci pwm devices can make use of this
core driver framework.

Thanks and Regards,
Arun R Murthy
-------------
