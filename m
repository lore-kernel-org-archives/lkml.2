Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab2K2B0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:26:22 -0500
Received: from [216.32.180.184] ([216.32.180.184]:29044 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754756Ab2K2B0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:26:20 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1de0h1202h1d1ah1d2ahzz17326ah8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 29 Nov 2012 09:51:36 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mike Turquette <mturquette@ti.com>
CC: Mark Langsdorf <mark.langsdorf@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 6/6 v6] cpufreq, highbank: add support for highbank
 cpufreq
Message-ID: <20121129015133.GD28170@S2100-06.ap.freescale.net>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354046672-7392-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354046672-7392-7-git-send-email-mark.langsdorf@calxeda.com>
 <20121128023240.GA28170@S2100-06.ap.freescale.net>
 <50B60E9C.9000405@calxeda.com>
 <20121128145759.GB28170@S2100-06.ap.freescale.net>
 <20121128151741.GC28170@S2100-06.ap.freescale.net>
 <20121128160115.21126.3841@nucleus>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121128160115.21126.3841@nucleus>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The notifiers in the clk framework might be a better place for this than
> just simply hacking the logic into the .set_rate callback.

Ah, right.  How did I forget about that nice piece?

> I haven't looked at the definition of hb_voltage_change but does the
> call graph make any clk api calls?  Are you talking over i2c to a
> regulator?  If so then you'll probably hit the same reentrancy problem I
> hit when trying to make a general solution.

So, how is your "reentrancy in the common clk framework" series[1]
going on?  Haven't seen any update since August.

Shawn

[1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/182198

