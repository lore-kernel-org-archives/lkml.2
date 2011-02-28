Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab1B1HtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 02:49:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37637 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab1B1HtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 02:49:11 -0500
Date: Mon, 28 Feb 2011 08:49:09 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/3] mfd: mc13xxx-core: add MODULE_DEVICE_TABLE
Message-ID: <20110228074909.GI22310@pengutronix.de>
References: <1298874735.5562.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1298874735.5562.3.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Axel,

On Mon, Feb 28, 2011 at 02:32:15PM +0800, Axel Lin wrote:
> The device table is required to load modules based on modaliases.
> After adding the MODULE_DEVICE_TABLE, below entries will be added to
> modules.alias:
> alias spi:mc13892 mc13xxx_core
> alias spi:mc13783 mc13xxx_core
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
