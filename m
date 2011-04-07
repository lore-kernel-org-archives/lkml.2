Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab1DGTQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 15:16:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42803 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab1DGTQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 15:16:15 -0400
Date: Thu, 7 Apr 2011 21:15:53 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: oskar.andero@sonyericsson.com
Cc: nbowler@elliptictech.com, pebolle@tiscali.nl, nicolas.pitre@linaro.org,
        linux@arm.linux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, eric.y.miao@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        Victor Boivie <victor.boivie@sonyericsson.com>
Subject: Re: [PATCH] ARM: Allow for kernel command line concatenation
Message-ID: <20110407191553.GA8569@pengutronix.de>
References: <1302182968-16708-1-git-send-email-oskar.andero@sonyericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302182968-16708-1-git-send-email-oskar.andero@sonyericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 07, 2011 at 03:29:28PM +0200, oskar.andero@sonyericsson.com wrote:
> From: Victor Boivie <victor.boivie@sonyericsson.com>
> 
> This patch allows the provided CONFIG_CMDLINE to be concatenated
> with the one provided by the boot loader. This is useful to
> merge the static values defined in CONFIG_CMDLINE with the
> boot loader's (possibly) more dynamic values, such as startup
> reasons and more.
> 
> Signed-off-by: Victor Boivie <victor.boivie@sonyericsson.com>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@sonyericsson.com>
> Signed-off-by: Oskar Andero <oskar.andero@sonyericsson.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
