Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0LIOeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 09:34:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52124 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab0LIOet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 09:34:49 -0500
Date: Thu, 9 Dec 2010 15:34:45 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Arnaud Patard <arnaud.patard@rtp-net.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhang Lily-R58066 <r58066@freescale.com>
Subject: Re: [PATCH 2/9] ARM i.MX51: rename IPU irqs
Message-ID: <20101209143445.GX17441@pengutronix.de>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de> <1291902441-24712-3-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291902441-24712-3-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 02:47:14PM +0100, Sascha Hauer wrote:
> -#define MX51_MXC_INT_IPU_ERR		10
> -#define MX51_MXC_INT_IPU_SYN		11
> +#define MX51_INT_IPU_ERR		10
> +#define MX51_INT_IPU_SYN		11
This one is easy.  Acked-by: me.  Maybe it's worth to do

	git ls-files | xargs perl -p -i -e 's/\bMX51_MXC_INT_/MX51_INT_/

and then fix up the layout damage.

Best regards
Uwe


-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
