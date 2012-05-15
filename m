Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab2EOGiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 02:38:54 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:21178
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753710Ab2EOGix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 02:38:53 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 15 May 2012 14:44:03 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Dong Aisheng-B29396 <B29396@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 1/2] pinctrl: pinctrl-imx: add imx53 pinctrl driver
Message-ID: <20120515064401.GA10347@shlinux2.ap.freescale.net>
References: <1337010369-28687-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1337010369-28687-1-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 11:46:08PM +0800, Dong Aisheng-B29396 wrote:
> +See below for available PIN_FUNC_ID for imx53:
> +MX53_PAD_GPIO_19__KPP_COL_5				1
To align with mx6, the id base in the binding doc should start from 0.
Will update the doc in v2.

> +MX53_PAD_GPIO_19__GPIO4_5				2
> +MX53_PAD_GPIO_19__CCM_CLKO				3
> +MX53_PAD_GPIO_19__SPDIF_OUT1				4
> +MX53_PAD_GPIO_19__RTC_CE_RTC_EXT_TRIG2			5
> +MX53_PAD_GPIO_19__ECSPI1_RDY				6
...

Regards
Dong Aisheng

