Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab0JJToQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 15:44:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37113 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab0JJToP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 15:44:15 -0400
Date: Sun, 10 Oct 2010 21:44:05 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: arm/imx: fix memory init in imx_dma_request()
Message-ID: <20101010194405.GS29673@pengutronix.de>
References: <1286731703-17775-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1286731703-17775-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 09:28:23PM +0400, Vasiliy Kulikov wrote:
> imx_dma_request() didn't fill struct pointed by imxdma with zeroes
> as it passed sizeof(pointer), not sizeof(struct) to memset().
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Acked-and-tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
