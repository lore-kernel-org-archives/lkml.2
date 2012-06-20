Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab2FTFKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 01:10:41 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:40775
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342Ab2FTFKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 01:10:39 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202hzz8275dhz2dh2a8h668h839h944hd25hf0ah)
Date: Wed, 20 Jun 2012 13:07:04 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>
Subject: Re: [PATCH 1/1] pinctrl: pinctrl-mxs: fix a compiling error
Message-ID: <20120620050703.GF10387@shlinux2.ap.freescale.net>
References: <1340167717-13082-1-git-send-email-b29396@freescale.com>
 <20120620052312.GA1568@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120620052312.GA1568@S2100-06.ap.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 01:23:15PM +0800, Shawn Guo wrote:
> On Wed, Jun 20, 2012 at 12:48:37PM +0800, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > The compiling error is:
> > drivers/pinctrl/pinctrl-mxs.c: In function 'mxs_dt_node_to_map':
> > drivers/pinctrl/pinctrl-mxs.c:140: error: implicit declaration of function 'free'
> > drivers/pinctrl/pinctrl-mxs.c:140: warning: incompatible implicit declaration of built-in function 'free'
> > It should be kfree.
> > 
> 
> Already fixed by Fabio.
> 
> http://git.kernel.org/?p=linux/kernel/git/linusw/linux-pinctrl.git;a=commit;h=14e1e9f5cadb7cff3a2846c27cc1b9c8f207ee18
> 
Sorry, missed it.

Regards
Dong Aisheng

