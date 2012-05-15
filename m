Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab2EONAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:00:46 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:29568
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932824Ab2EONAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:00:43 -0400
X-SpamScore: -10
X-BigFish: VS-10(zz9371I1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 15 May 2012 21:05:43 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 1/2] pinctrl: pinctrl-imx: add imx53 pinctrl driver
Message-ID: <20120515130542.GD10347@shlinux2.ap.freescale.net>
References: <1337010369-28687-1-git-send-email-b29396@freescale.com>
 <CACRpkdbW8eeq0gFTjPRpKesmV4K5zqRHuW6C-UywBn8AtqOLCg@mail.gmail.com>
 <20120515112732.GB10347@shlinux2.ap.freescale.net>
 <CACRpkdaKAF8bznd-sBdcGfdJW_cHSUGFZhnVk4qJ_0LJ8GoUuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACRpkdaKAF8bznd-sBdcGfdJW_cHSUGFZhnVk4qJ_0LJ8GoUuQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 08:33:58PM +0800, Linus Walleij wrote:
> On Tue, May 15, 2012 at 1:27 PM, Dong Aisheng
> <aisheng.dong@freescale.com> wrote:
> > On Tue, May 15, 2012 at 07:10:58PM +0800, Linus Walleij wrote:
> >> Dong, will you merge the i.MX stuff through pinctrl or through
> >> ARM SoC?
> >
> > This patch has no dependency on any arm soc stuffs.
> > I think it's ok to go through pinctrl.
> 
> OK I'll be merging them, I was just thinking if you planned to also
> make machine changes in this kernel cycle.
> 
I did not plan it before, i checked with Shawn and he was also ok to
go through pinctrl tree.

Thanks

Regards
Dong Aisheng

