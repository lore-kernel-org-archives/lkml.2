Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0HWTDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 15:03:55 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:34344 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab0HWTDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 15:03:53 -0400
Date: Mon, 23 Aug 2010 21:03:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Mack <daniel@caiaq.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        Hemanth V <hemanthv@ti.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Paul Gortmaker <p_gortmaker@yahoo.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Roy Zang <tie-fei.zang@freescale.com>,
        Jingchang Lu <b22599@freescale.com>,
        Mingkai Hu <Mingkai.hu@freescale.com>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] i2c: remove obsolete cleanup for clientdata
Message-ID: <20100823210336.6bdc8e2a@hyperion.delvare>
In-Reply-To: <1282575908-16555-1-git-send-email-w.sang@pengutronix.de>
References: <1282575908-16555-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 17:05:08 +0200, Wolfram Sang wrote:
> A few new i2c-drivers came into the kernel which clear the clientdata-pointer
> on exit. This is obsolete meanwhile, so fix it and hope the word will spread.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
> 
> Jean, I dunno if it fits for 2.6.36. It is not precisely a regression.
> Though, if it enters with the next merge window, the next set of "faulty"
> drivers may come in at the same time...

Applied, and queued for 2.6.36. I agree that this kind of cleanup fits
well as an exception to the bugfix-only rule.

-- 
Jean Delvare
