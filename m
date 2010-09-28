Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab0I1Ksz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 06:48:55 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:52034 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750952Ab0I1Ksx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 06:48:53 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
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
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Date: Tue, 28 Sep 2010 12:48:12 +0200
Subject: RE: [PATCH 3/7] leds: pwm: add a new element 'name' to platform data
Thread-Topic: [PATCH 3/7] leds: pwm: add a new element 'name' to platform
 data
Thread-Index: Acte+jRWeNi88ekyQ5KOTcl29A0fyAAAFG4A
Message-ID: <F45880696056844FA6A73F415B568C69532DC2FC97@EXDCVYMBSTM006.EQ1STM.local>
References: <1285670134-18063-1-git-send-email-arun.murthy@stericsson.com>
 <1285670134-18063-4-git-send-email-arun.murthy@stericsson.com>
 <4CA1C6C4.20504@mvista.com>
In-Reply-To: <4CA1C6C4.20504@mvista.com>
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

> > @@ -16,6 +16,7 @@ struct led_pwm {
> >   struct led_pwm_platform_data {
> >   	int			num_leds;
> >   	struct led_pwm	*leds;
> > +	char *name;
> >   };
> 
>     Shouldn't '*name'be aligned, at least with '*leds'?
Sure, will take care of this in the v2 patch.

Thanks and Regards,
Arun R Murthy
-------------
