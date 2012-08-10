Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055Ab2HJBkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 21:40:49 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:58597
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757957Ab2HJBkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 21:40:47 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1202hzzz2dh87h2a8h668h839h944hd25he96hf0ah107ah)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 10 Aug 2012 09:41:22 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Matt Sealey <matt@genesi-usa.com>
CC: Fabio Estevam <festevam@gmail.com>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] efikamx: reintroduce Genesi Efika MX Smarttop via device
 tree
Message-ID: <20120810014119.GD19617@S2101-09.ap.freescale.net>
References: <1344375978-29981-1-git-send-email-matt@genesi-usa.com>
 <20120808151555.GE14718@S2101-09.ap.freescale.net>
 <CAKGA1bkbp8_z+HSr97cp_jeCrdTHkQxuZPFu0QPWwnXphWVdZA@mail.gmail.com>
 <CAOMZO5DOEfV4wTSNW8ABaUhGwa_KG3Bkt0o-rs8k-cZk4P-=+A@mail.gmail.com>
 <CAKGA1bkOo=En2P18FaBpq_KAZ88kisikXhNTabvnDknQ-EwFjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKGA1bkOo=En2P18FaBpq_KAZ88kisikXhNTabvnDknQ-EwFjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 09:29:39AM -0500, Matt Sealey wrote:
> The reason the new kernel depends on the new U-Boot is we're trying to
> do all pinmux configuration in U-Boot (and we do in-house, and it
> works). No pinctrl stuff in the kernel or device tree is required at
> this point. The Old Kernel will remux a few things redundantly or
> change drive strengths or whatever or add hysteresis to the UART port
> which is not board-burning but is not really necessary, but it will
> work. The new kernel will just be able to do what it does out of the
> box, which is how it should be (hence why I object to adding pinctrl
> setup...)
> 
Then I will have to refuse to accept your patch, because I'm working on
a series to remove pinctrl_provide_dummies() from imx51_dt_init().

-- 
Regards,
Shawn

