Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab2HJODf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:03:35 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:8166
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756320Ab2HJODe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:03:34 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1202hzzz2dh87h2a8h668h839h944hd25he96hf0ah107ah)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 10 Aug 2012 22:04:08 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Matt Sealey <matt@genesi-usa.com>
CC: Fabio Estevam <festevam@gmail.com>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] efikamx: reintroduce Genesi Efika MX Smarttop via device
 tree
Message-ID: <20120810140406.GB3409@S2101-09.ap.freescale.net>
References: <1344375978-29981-1-git-send-email-matt@genesi-usa.com>
 <20120808151555.GE14718@S2101-09.ap.freescale.net>
 <CAKGA1bkbp8_z+HSr97cp_jeCrdTHkQxuZPFu0QPWwnXphWVdZA@mail.gmail.com>
 <CAOMZO5DOEfV4wTSNW8ABaUhGwa_KG3Bkt0o-rs8k-cZk4P-=+A@mail.gmail.com>
 <CAKGA1bkOo=En2P18FaBpq_KAZ88kisikXhNTabvnDknQ-EwFjA@mail.gmail.com>
 <20120810014119.GD19617@S2101-09.ap.freescale.net>
 <CAKGA1bmd-53G=59F7Nsd3Sx2eEQgvcahnt3g5zxJAGawtc-gWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKGA1bmd-53G=59F7Nsd3Sx2eEQgvcahnt3g5zxJAGawtc-gWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 08:36:02AM -0500, Matt Sealey wrote:
> Requiring it breaks the entire concept of the device tree to describe running
> hardware. It is not a configuration script. pinctrl should be optional
> - built in
> always, but not necessary to turn a board on if it's already configured.
> 
How would kernel know if it's already configured, correctly?

> What would happen if a board were designed that only used the default ALT
> settings on i.MX53 or so? You'd have to redefine every default IOMUX pad
> just to get it to boot. That's intolerable.
> 
Come on, even the pad configuration are all the default?  Even if that's
the case, yes, we still need to do it.  How do we know if firmware has
changed the settings or not.

-- 
Regards,
Shawn

