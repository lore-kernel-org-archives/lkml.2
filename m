Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1JOCek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 22:34:40 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:42489
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303Ab1JOCei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 22:34:38 -0400
X-SpamScore: 7
X-BigFish: VS7(z1039ozzz1202hzzz2dh87h2a8h668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Sat, 15 Oct 2011 10:34:30 +0800
From: Richard Zhao <richard.zhao@linaro.org>
To: "Turquette, Mike" <mturquette@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <paul@pwsan.com>,
        <linaro-dev@lists.linaro.org>, <linus.walleij@stericsson.com>,
        <patches@linaro.org>, <sboyd@quicinc.com>,
        <broonie@opensource.wolfsonmicro.com>, <magnus.damm@gmail.com>,
        <linux-kernel@vger.kernel.org>, <amit.kucheria@linaro.org>,
        <grant.likely@secretlab.ca>, <dsaxena@linaro.org>,
        <tglx@linutronix.de>, <eric.miao@linaro.org>, <linux@arm.linux.org.uk>,
        <skannan@quicinc.com>, <jeremy.kerr@canonical.com>,
        <shawn.guo@freescale.com>, <arnd.bergmann@linaro.org>
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Message-ID: <20111015023428.GA18134@b20223-02.ap.freescale.net>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-2-git-send-email-mturquette@ti.com>
 <CAJOA=zM9k7_z_PUoF0tZ_OrgdDTgMjZLftqtW0ra3G9C08Th7g@mail.gmail.com>
 <20111015022448.GA17872@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111015022448.GA17872@b20223-02.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - When I define a clk array, I don't need to find another place to store .ops.
                                  ^^^^^
remove "don't". sorry for that.
 

