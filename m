Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590Ab2EPHkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:40:46 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:53676
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759457Ab2EPHkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:40:45 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz154dM1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 16 May 2012 15:45:31 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Dong Aisheng-B29396 <B29396@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 1/2] pinctrl: pinctrl-imx: add imx53 pinctrl driver
Message-ID: <20120516074530.GE10347@shlinux2.ap.freescale.net>
References: <1337068143-15579-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1337068143-15579-1-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, May 15, 2012 at 03:49:02PM +0800, Dong Aisheng-B29396 wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
> ChangeLog v1->v2:
> * change PIN_FUNC_ID base in binding doc to 0 from 1.
I just checked your tree and it seems you merged the v1 series.
Can you merge this v2 instead?
I'm sorry that this patch title missed a v2 flag which caused you some
inconvenience.

Regards
Dong Aisheng

