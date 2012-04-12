Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762223Ab2DLI4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 04:56:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48257 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2DLI43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 04:56:29 -0400
Date: Thu, 12 Apr 2012 10:56:28 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: arnd.bergmann@linaro.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH 00/13] common clk framework misc fixes
Message-ID: <20120412085628.GE20478@pengutronix.de>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:53:38 up 151 days, 16:40, 67 users,  load average: 0.10, 0.21,
 0.48
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 06:02:38PM -0700, Mike Turquette wrote:
> This series collects many of the fixes posted for the recently merged
> common clock framework as well as some general clean-up.  Most of the
> code classifies as a clean-up moreso than a bug fix; hopefully this is
> not a problem since the common clk framework is new code pulled for 3.4.
> 
> Patches are based on v3.4-rc2 and can be pulled from:
> git://git.linaro.org/people/mturquette/linux.git v3.4-rc2-clk-fixes
> 
> Please let me know I missed any critical fixes that were posted to the
> list already.
> 
> Arnd & Olof, if there are no objections to these changes can this get
> pulled through the arm-soc tree?

I had a look at this series and except for the comment Shawn already
made I am fine with it. I also vote for queuing it during -rc since
the framework currently has no users and letting it into -rc will help
people like me putting SoC support onto it.

Except the last patch:

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
