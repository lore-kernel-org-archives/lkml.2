Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab2IJJ2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:28:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38053 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab2IJJ2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:28:07 -0400
Date: Mon, 10 Sep 2012 11:28:02 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Oskar Schirmer <oskar@scara.com>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial/imx: fix IMX UART macro usage to reflect correct
Message-ID: <20120910092802.GY28643@pengutronix.de>
References: <1347268775-25253-1-git-send-email-oskar@scara.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1347268775-25253-1-git-send-email-oskar@scara.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 09:19:35AM +0000, Oskar Schirmer wrote:
> Platform dependant UART data refers to MX31 macro for MX35 machines.
> For all other machines, macro usage matches machine type.
> 
> Though this compiles out to the same result, it looks much like
> a typo, so fix it to use the right macros instead.
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe
