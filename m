Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab2D0DEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 23:04:01 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:17963
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758551Ab2D0DEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 23:04:00 -0400
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 27 Apr 2012 11:13:32 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/2] pinctrl: support gpio request deferred probing
Message-ID: <20120427031331.GD26070@shlinux2.ap.freescale.net>
References: <1335353894-22096-1-git-send-email-b29396@freescale.com>
 <CACRpkdadLsqpb=X+BmomyRywf=SrgGpbW2B=Myo3zTn_xMHJ2g@mail.gmail.com>
 <4F9A01B6.2050502@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F9A01B6.2050502@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Apr 27, 2012 at 10:17:26AM +0800, Stephen Warren wrote:
> On 04/26/2012 03:36 PM, Linus Walleij wrote:
> > On Wed, Apr 25, 2012 at 1:38 PM, Dong Aisheng <b29396@freescale.com> wrote:
> > 
> >> From: Dong Aisheng <dong.aisheng@linaro.org>
> >>
> >> As pinctrl handles, it may be possible the pinctrl gpio ranges
> >> are still not got registered when user call pinctrl_gpio_request.
> >> Thus, add defer support for it too.
> >>
> >> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > Since nobody is saying anything and it looks reasonable,
> > I just applied this.
> 
> I didn't look at this, because V4 was sent without this patch, so I
> assumed it'd been dropped by Dong. Was I wrong?
> 
I thought this patch had no relationship with dummy state v4 patch and
it had no changes, so i did not resend it out with the v4 patch again.
It did not mean drop. Sorry for causing confusing.
Anyway thanks for your attention.

Regards
Dong Aisheng

