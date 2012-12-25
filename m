Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2LYLIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 06:08:46 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:19935
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753641Ab2LYLIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 06:08:43 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 25 Dec 2012 19:08:48 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Matt Sealey <matt@genesi-usa.com>
CC: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH] ehci-mxc: remove Efika MX-specific CHRGVBUS hack
Message-ID: <20121225110845.GB14088@S2101-09.ap.freescale.net>
References: <1356261362-8418-1-git-send-email-matt@genesi-usa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1356261362-8418-1-git-send-email-matt@genesi-usa.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2012 at 05:16:02AM -0600, Matt Sealey wrote:
> Since Efika MX platform support (pre-devicetree) was removed from the tree
> this code no longer has any possibility of running and clutters up the
> driver which is being replaced by the chipidea host in the future anyway.
> 
> Signed-off-by: Matt Sealey <matt@genesi-usa.com>
> Tested-by: Steev Klimazewski <steev@genesi-usa.com>
> CC: Sascha Hauer <kernel@pengutronix.de>
> CC: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

