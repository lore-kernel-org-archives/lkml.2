Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab2ETBup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 21:50:45 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:53068
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754376Ab2ETBun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 21:50:43 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z1039oz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25hf0ah)
Date: Sun, 20 May 2012 10:10:11 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Shawn Guo <shawn.guo@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "Hans J. Koch" <hjk@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ryan Mallon <rmallon@gmail.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        <LW@KARO-electronics.de>, Sascha Hauer <s.hauer@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] gpio/generic: initialize basic_mmio_gpio shadow
 variables properly
Message-ID: <20120520021009.GA5810@S2100-06.ap.freescale.net>
References: <1337417751-24848-1-git-send-email-shawn.guo@linaro.org>
 <20120519181242.B87193E03B8@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120519181242.B87193E03B8@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 12:12:42PM -0600, Grant Likely wrote:
> On Sat, 19 May 2012 16:55:51 +0800, Shawn Guo <shawn.guo@linaro.org> wrote:
> > It fixes the issue in gpio-generic that commit fb14921 (gpio/mxc: add
> > missing initialization of basic_mmio_gpio shadow variables) manged to
> > fix in gpio-mxc driver, so that other platform specific drivers do not
> > suffer from the same problem over and over again.
> > 
> > Changes since v1:
> > * Turn the last parameter "bool big_endian" into "unsigned long flags"
> >   and give those really quirky hardwares a chance to tell that reg_set
> >   and reg_dir are unreadable.
> > 
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> 
> Applied, thanks.
> 
Grant,

Can you please pick up the RESEND version of the patch, which had
bgpio_pdev_probe adapt bgpio_init parameter change too?

-- 
Regards,
Shawn

