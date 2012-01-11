Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931Ab2AKTVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 14:21:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50491 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933339Ab2AKTVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 14:21:19 -0500
Date: Wed, 11 Jan 2012 20:21:14 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Michael Thalmeier <michael.thalmeier@hale.at>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, michael@thalmeier.at
Subject: Re: [PATCH v2] input/mc13783-ts: add pdata to set conversion delay
Message-ID: <20120111192114.GP14252@pengutronix.de>
References: <1326278963-22510-1-git-send-email-michael.thalmeier@hale.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1326278963-22510-1-git-send-email-michael.thalmeier@hale.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 11:49:23AM +0100, Michael Thalmeier wrote:
> MC13783 can be programmed to wait some clock cycles between the touch screen
> polarization and the resistance conversion. This is needed to adjust for
> touchscreens with high capacitance between plates.
> 
> Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
Looks good for me.

Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe
-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
