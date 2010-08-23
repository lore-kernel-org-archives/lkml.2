Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab0HWPWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:22:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50769 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751589Ab0HWPWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:22:14 -0400
Date: Mon, 23 Aug 2010 16:22:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Mack <daniel@caiaq.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        Hemanth V <hemanthv@ti.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
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
Message-ID: <20100823152212.GA19774@rakim.wolfsonmicro.main>
References: <1282575908-16555-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282575908-16555-1-git-send-email-w.sang@pengutronix.de>
X-Cookie: ... I have read the INSTRUCTIONS ...
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 05:05:08PM +0200, Wolfram Sang wrote:
> A few new i2c-drivers came into the kernel which clear the clientdata-pointer
> on exit. This is obsolete meanwhile, so fix it and hope the word will spread.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
