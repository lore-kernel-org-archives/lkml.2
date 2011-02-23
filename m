Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1BWIPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 03:15:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42243 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab1BWIPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 03:15:51 -0500
Date: Wed, 23 Feb 2011 09:15:39 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] wip: convert imx27 to common struct clk
Message-ID: <20110223081539.GM22310@pengutronix.de>
References: <1298256658.861611.43913489619.0.gpush@pororo>
 <1298417599-23522-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <4D648A3D.7020402@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D648A3D.7020402@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Saravana,

On Tue, Feb 22, 2011 at 08:17:01PM -0800, Saravana Kannan wrote:
> On 02/22/2011 03:33 PM, Uwe Kleine-König wrote:
> >I had to degrade one WARN_ON to WARN_ON_ONCE in drivers/clk/clk.c to
> >actually make it work.  Otherwise console output results in a warning
> >that results in console output ...
> 
> You won't be able to do mainline the WARN_ON_ONCE because that will
> only warn for the first clock that violates whatever condition it's
> warning about.
I wonder if it is more sensible while the warning is new.  But I don't
care much because I'm going to fix the serial driver before switching.
 
Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
