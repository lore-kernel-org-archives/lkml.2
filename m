Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1LSXKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:10:16 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:17217
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772Ab1LSXKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:10:13 -0500
X-SpamScore: -14
X-BigFish: VS-14(zz1447M1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 20 Dec 2011 07:23:27 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Marek Vasut <marek.vasut@gmail.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Wolfgang Denk <wd@denx.de>, Sascha Hauer <s.hauer@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, Huang Shijie <b32955@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@linaro.org>, Stefano Babic <sbabic@denx.de>
Subject: Re: [PATCH] MXS: Convert mutexes in clock.c to spinlocks
Message-ID: <20111219232325.GA5683@S2100-06.ap.freescale.net>
References: <1324217174-6574-1-git-send-email-marek.vasut@gmail.com>
 <201112191257.06145.marek.vasut@gmail.com>
 <20111219121559.GF14542@n2100.arm.linux.org.uk>
 <201112192154.25310.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201112192154.25310.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 09:54:25PM +0100, Marek Vasut wrote:
> > So, in summary, you have everything you require to fix it outside the
> > driver.  You just have to decide which of the two options you want to
> > proceed with, and actually (and finally) do it instead of endlessly
> > procrastinating and waiting for more and more bug reports (which is
> > exactly what has happened so far.)
> 

Marek, the 'you' here really means me rather than you.

Russell, sorry for leaving the issue here for long time, and I'm working
on the patches you suggested right now.

Regards,
Shawn

> What the hell, I just recently found this bug and I submitted a patch right 
> away! What are you complaining about?!
> 
> Grumble!
> 
> But thanks for the explanation!
> 
> M
> 

