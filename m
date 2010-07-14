Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0GNOvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:51:15 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:35065 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751489Ab0GNOvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:51:13 -0400
Date: Wed, 14 Jul 2010 20:20:54 +0530
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
Message-ID: <20100714145053.GA1689@bnru01.bnr.st.com>
References: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
 <1279030173-3086-2-git-send-email-sundar.iyer@stericsson.com>
 <20100713141828.GB24260@rakim.wolfsonmicro.main>
 <33A307AF30D7BF4F811B1568FE7A9B1810E7E88D@EXDCVYMBSTM006.EQ1STM.local>
 <20100713145645.GA24626@rakim.wolfsonmicro.main>
 <20100713150814.GA13767@bnru01.bnr.st.com>
 <20100713150905.GD24626@rakim.wolfsonmicro.main>
 <20100713161343.GA25342@bnru01.bnr.st.com>
 <20100713203852.GA1756@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100713203852.GA1756@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Thanks

> > +struct regulator_init_data ab8500_vaudio_init = {
> > +	.supply_regulator_dev = NULL,
> > +	.constraints = {
> > +		.name = "ab8500-vaudio",
> > +		.min_uV = 1925000,
> > +		.max_uV = 2075000,
> 
> Are you *sure* that all these constraints are accurate for the board?
As far as the min/max values of the voltage go, yes they are as per the
data sheet.

> It seems every single voltage is variable even though there are no
> consumers set up, and they can all be disabled too.
Yes. all these regulators can be disabled/enabled. does this answer your
qeury? ( or i didnt understand it properly??)

Thanks,
Sundar
