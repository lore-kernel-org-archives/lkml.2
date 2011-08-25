Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab1HYH5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 03:57:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49936 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1HYH5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 03:57:30 -0400
Date: Thu, 25 Aug 2011 09:57:19 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
Cc: linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Jander <david@protonic.nl>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Richard Purdie <rpurdie@rpsys.net>,
        kernel@pengutronix.de, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 0/6] mc13783 cleanup
Message-ID: <20110825075719.GL16557@pengutronix.de>
References: <20110824132740.GA28197@pengutronix.de>
 <201108250905.13168.philippe.retornaz@epfl.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201108250905.13168.philippe.retornaz@epfl.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 09:05:12AM +0200, Philippe Rétornaz wrote:
> Le mercredi 24 août 2011 15:27:40, Uwe Kleine-König a écrit :
> > Hello,
> > 
> > this series removes the long obsolte mc13783 API after fixing all
> > remaining users.
> 
> I posted a patch last month which was touching this MFD too.
> We will need to synchronize both patch. 
Ah right. At one point I remembered your patch set because I wondered
that ..._USE_REGULATOR is still used.

Assuming all involved people are OK with both patch sets I can do the
merge of both patch sets.
 
Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
