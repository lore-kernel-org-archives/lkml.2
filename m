Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab0GMPIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 11:08:31 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:53847 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754713Ab0GMPI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 11:08:29 -0400
Date: Tue, 13 Jul 2010 20:38:15 +0530
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
Message-ID: <20100713150814.GA13767@bnru01.bnr.st.com>
References: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
 <1279030173-3086-2-git-send-email-sundar.iyer@stericsson.com>
 <20100713141828.GB24260@rakim.wolfsonmicro.main>
 <33A307AF30D7BF4F811B1568FE7A9B1810E7E88D@EXDCVYMBSTM006.EQ1STM.local>
 <20100713145645.GA24626@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100713145645.GA24626@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm pretty sure that people will be able to figure out how to add a
> consumer list by themselves when they need it, and the lists you're
> currently including are actively harmful in that they are encouraging
> people to hard code board specific supply names or start passing supply
> names around as platform data.
OK. so I include only regulator_init_data and keep the
regulator_consumer_supply empty. Is this the right thing forward?

Regards,
Sundar
