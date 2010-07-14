Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab0GNPhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:37:15 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:44843 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757109Ab0GNPhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:37:12 -0400
Date: Wed, 14 Jul 2010 21:06:44 +0530
From: Sundar R IYER <sundar.iyer@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH v2 2/2] ux500: add ab8500-regulators machine specific
 data
Message-ID: <20100714153643.GB1689@bnru01.bnr.st.com>
References: <1279030173-3086-2-git-send-email-sundar.iyer@stericsson.com>
 <20100713141828.GB24260@rakim.wolfsonmicro.main>
 <33A307AF30D7BF4F811B1568FE7A9B1810E7E88D@EXDCVYMBSTM006.EQ1STM.local>
 <20100713145645.GA24626@rakim.wolfsonmicro.main>
 <20100713150814.GA13767@bnru01.bnr.st.com>
 <20100713150905.GD24626@rakim.wolfsonmicro.main>
 <20100713161343.GA25342@bnru01.bnr.st.com>
 <20100713203852.GA1756@rakim.wolfsonmicro.main>
 <20100714145053.GA1689@bnru01.bnr.st.com>
 <20100714145748.GF31073@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100714145748.GF31073@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which datasheet, and will the system design actually be varying them at
> runtime - if it will how will it do so?  This is the settings for the
> particular system and generally a lot of these rails will get fixed at
> design time for various reasons (for example, the analogue supplies will
> usually depend on the analogue system design).
I am referring to the AB8500 device data sheet; not sure if its
available open.  I have taken the minimal/maximum figures as what is
mentioned for each supplies.

> Again, is it really the case that this will happen in this system?
Yes, if you are referring to regulator enable/disable.

> Nothing is currently able to actually do that, and unless every consumer
> using a given supply is hooked into the regulator API things will go
> wrong when some of them start doing so.
As i said earlier, my intention is to hard code the machine constraints.
The actual control in terms of enable/disable, controlling supply
voltages will happen, as you say when consumers are hooked up.

Thanks,
Sundar
