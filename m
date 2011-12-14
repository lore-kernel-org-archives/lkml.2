Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1LNHuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:50:21 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:54709
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753216Ab1LNHuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:50:18 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 14 Dec 2011 15:50:04 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Mike Turquette <mturquette@linaro.org>
CC: <linux@arm.linux.org.uk>, <andrew@lunn.ch>, <linaro-dev@lists.linaro.org>,
        <eric.miao@linaro.org>, <grant.likely@secretlab.ca>,
        <jeremy.kerr@canonical.com>, <mturquette@ti.com>, <sboyd@quicinc.com>,
        <magnus.damm@gmail.com>, <dsaxena@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <arnd.bergmann@linaro.org>,
        <patches@linaro.org>, <tglx@linutronix.de>,
        <linux-omap@vger.kernel.org>, <richard.zhao@linaro.org>,
        <shawn.guo@freescale.com>, <paul@pwsan.com>,
        <linus.walleij@stericsson.com>, <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, <amit.kucheria@linaro.org>,
        <skannan@quicinc.com>
Subject: Re: [PATCH v4 3/6] clk: introduce the common clock framework
Message-ID: <20111214074922.GM28768@b20223-02.ap.freescale.net>
References: <1323834838-2206-1-git-send-email-mturquette@linaro.org>
 <1323834838-2206-4-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1323834838-2206-4-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,
> + *
> + * @recalc_rate	Recalculate the rate of this clock, by quering hardware
> + * 		and/or the clock's parent. It is up to the caller to insure
> + * 		that the prepare_mutex is held across this call.  Returns the
> + * 		calculated rate.  Optional, but recommended - if this op is not
> + * 		set then clock rate will be initialized to 0.
I'm still concerned, if it's NULL, why don't just retrun parent's rate if it has? 
 
Thanks
Richard

