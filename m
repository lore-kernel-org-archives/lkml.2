Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0KIWMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:12:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43412 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab0KIWMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:12:15 -0500
Date: Tue, 9 Nov 2010 23:12:13 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        amit.kucheria@canonical.com, eric@eukrea.com
Subject: Re: [PATCHv3 2/2] ARM: imx: Add mx53 support to common msl
	functions.
Message-ID: <20101109221213.GC16938@pengutronix.de>
References: <1288972551-21877-1-git-send-email-Dinh.Nguyen@freescale.com> <1288972551-21877-2-git-send-email-Dinh.Nguyen@freescale.com> <20101109220207.GH6017@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101109220207.GH6017@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > -	if (!cpu_is_mx51())
> > +	if (!cpu_is_mx51() || !cpu_is_mx53())
> >  		return 0;
> 
> The code below runs for every SoC except i.MX51 and i.MX53. This is
> surely not what you want.
Hmm, for i.MX51 !cpu_is_mx53() is true, so the return 0 is always taken,
isn't it? :-)

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
