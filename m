Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab1LTDJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 22:09:18 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54186 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab1LTDJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 22:09:13 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH] MXS: Convert mutexes in clock.c to spinlocks
Date: Tue, 20 Dec 2011 04:09:03 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Wolfgang Denk <wd@denx.de>, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, Huang Shijie <b32955@freescale.com>,
        linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        Stefano Babic <sbabic@denx.de>
References: <1324217174-6574-1-git-send-email-marek.vasut@gmail.com> <201112200035.52802.marek.vasut@gmail.com> <20111220001946.GB5683@S2100-06.ap.freescale.net>
In-Reply-To: <20111220001946.GB5683@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112200409.04529.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Dec 20, 2011 at 12:35:52AM +0100, Marek Vasut wrote:
> > > On Mon, Dec 19, 2011 at 09:54:25PM +0100, Marek Vasut wrote:
> > > > > So, in summary, you have everything you require to fix it outside
> > > > > the driver.  You just have to decide which of the two options you
> > > > > want to proceed with, and actually (and finally) do it instead of
> > > > > endlessly procrastinating and waiting for more and more bug
> > > > > reports (which is exactly what has happened so far.)
> > > 
> > > Marek, the 'you' here really means me rather than you.
> > 
> > Sure, I figured as much after Russells reply.
> > 
> > > Russell, sorry for leaving the issue here for long time, and I'm
> > > working on the patches you suggested right now.
> > 
> > I see ... shall I back off from this issue then? Can I somehow help you
> > on this?
> 
> I will try to work out the series soon, and you can help to see if it
> solves your problem.

All right, I'll be glad to review. Make sure to Cc me :)

Cheers!

M
