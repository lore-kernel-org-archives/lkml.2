Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab2EXQka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:40:30 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1628 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752591Ab2EXQk2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:40:28 -0400
Message-ID: <1337877626.22505.30.camel@x61.thuisdomein>
Subject: Re: [PATCH] Drop superfluous setting of i2c_board_info.type
From: Paul Bolle <pebolle@tiscali.nl>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 24 May 2012 18:40:26 +0200
In-Reply-To: <20120524162230.GU3710@pengutronix.de>
References: <1337870303.22505.20.camel@x61.thuisdomein>
	 <20120524162230.GU3710@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-OriginalArrivalTime: 24 May 2012 16:40:26.0962 (UTC) FILETIME=[EC530320:01CD39CB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 18:22 +0200, Uwe Kleine-König wrote:
> On Thu, May 24, 2012 at 04:38:23PM +0200, Paul Bolle wrote:
> > 1) This is apparently legal. Doesn't gcc issue a warning for this?
> I wondered about that too, gcc doesn't even warn when the two values are
> different. See for example commit
> bd9e310dca15c9987256f67af19f9f42426e7493.

In that case it were two strings ("rtc-pcf8563" versus "pcf8563"). Why
should gcc care? Or is there something going on behind the scenes which
somehow depends on the contents of the string?
 
> >  arch/arm/mach-imx/mach-cpuimx35.c     |    1 -
> >  arch/arm/mach-imx/mach-cpuimx51sd.c   |    1 -
> I already submitted a patch for the imx bits with Message id
> 1335989287-10094-1-git-send-email-u.kleine-koenig@pengutronix.de.
> (e.g.
> http://mid.gmane.org/1335989287-10094-1-git-send-email-u.kleine-koenig@pengutronix.de)

Thanks. I missed that one, obviously. Should I just drop that part of
the patch and resend?

By the way, together with my previous patch (Message-ID
1337869829.22505.15.camel@x61.thuisdomein , probably not yet archived on
the web) we have found all instances of this issue, haven't we?

> Don't know if Sascha took it already. If he did, he didn't tell me.


Paul Bolle

