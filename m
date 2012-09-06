Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab2IFG6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 02:58:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44481 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2IFG6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 02:58:42 -0400
Date: Thu, 6 Sep 2012 08:58:34 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: =?iso-8859-15?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>,
        shawn guo <shawn.guo@linaro.org>,
        thierry reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/8] pwm i.MX: add devicetree support
Message-ID: <20120906065834.GL26594@pengutronix.de>
References: <1346852127-25226-6-git-send-email-s.hauer@pengutronix.de>
 <811985020.3713350.1346881354214.JavaMail.root@advansee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <811985020.3713350.1346881354214.JavaMail.root@advansee.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:57:35 up 74 days, 22:09, 50 users,  load average: 0.33, 0.24,
 0.30
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 11:42:34PM +0200, Benoît Thébaudeau wrote:
> 
> Since this is supposed to remove platform-based support, why don't you also
> remove the PWM stuff from arch/arm/plat-mxc and
> arch/arm/mach-imx/devices-imx*.h?

Simple answer: I was too lazy yesterday. I will include it in the next
round.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
