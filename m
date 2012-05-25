Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab2EYGfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 02:35:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44464 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab2EYGfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 02:35:20 -0400
Date: Fri, 25 May 2012 08:35:13 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Robert Lee <rob.lee@linaro.org>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org,
        u.kleine-koenig@pengutronix.de, richard.zhao@freescale.com,
        amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, jj@chaosbits.net
Subject: Re: [PATCH v5 0/7] cleanup imx5 idle, add imx5/6 cpuidle
Message-ID: <20120525063513.GG30400@pengutronix.de>
References: <1337640630-29176-1-git-send-email-rob.lee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337640630-29176-1-git-send-email-rob.lee@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:34:31 up 194 days, 14:21, 19 users,  load average: 0.00, 0.02,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Mon, May 21, 2012 at 05:50:23PM -0500, Robert Lee wrote:
> Cleanup up imx5 idle code and enable imx5 low powe idle for imx53.
> 
> Add common imx cpuidle initialization functionality and add a i.MX5 and i.MX6Q
> platform cpuidle implementation.

The series looks good now. We can take this right after the merge
window.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
