Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761249Ab2CPK5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:57:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36303 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761050Ab2CPK5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:57:12 -0400
Date: Fri, 16 Mar 2012 11:57:09 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH v7 0/3] common clk framework
Message-ID: <20120316105709.GC29317@pengutronix.de>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:07:54 up 124 days, 17:55, 68 users,  load average: 0.08, 0.11,
 1.79
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 11:11:17PM -0700, Mike Turquette wrote:
> The common clock framework defines a common struct clk as well as an
> implementation of the clk api that unifies clock operations on various
> platforms and devices.
> 
> The net result is consolidation of many different struct clk definitions
> and platform-specific clock framework implementations.
> 
> This series is the feature freeze for the common clock framework.
> Unless any major bugs are reported this should be the final version of
> this patchset.  Now is the time to add any acked-by's, reviewed-by's or
> tested-by's.  I've carried over the *-by's from v6; I hope everyone is
> OK with that.

Nice work, thanks again Mike. I gave it a test on various i.MX SoCs and
I can give you my:

Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
