Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab0EZTCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:02:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52323 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab0EZTCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:02:18 -0400
Date: Wed, 26 May 2010 21:02:15 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Baruch Siach <baruch@tkos.co.il>, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] fbdev: fix frame buffer devices menu
Message-ID: <20100526190215.GA11764@pengutronix.de>
References: <1274896477-6832-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1274896477-6832-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 26, 2010 at 02:54:37PM -0300, Thadeu Lima de Souza Cascardo wrote:
> Commit f601441916d1e19291d0b4f044b4a7551e2924d0 has inserted the symbol
> HAVE_FB_IMX, which does not depend on FB after the menuconfig FB. This
> breaks the menu, presenting most of the drivers outside of it, when
> using menuconfig.
> 
> Moving the symbol to the start of the file, just like HAVE_FB_ATMEL,
> fixes the problem without breaking it for iMX25 configurations (tested
> with ARCH=arm, no build).
> 
> Cc: Baruch Siach <baruch@tkos.co.il>
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
You're right,

Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
