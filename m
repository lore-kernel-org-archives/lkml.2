Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab1DZPhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:37:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41129 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab1DZPhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:37:41 -0400
Date: Tue, 26 Apr 2011 17:37:37 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Linus Walleij <linux.walleij@linaro.org>,
        linux-arm-msm@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Thomas Glexiner <tglx@linutronix.de>,
        Andres Salomon <dilinger@queued.net>, dwalker@fifo99.com,
        davidb@codeaurora.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PM8921 MFD V5 0/6] pm8921 core and subdevices
Message-ID: <20110426153737.GZ31131@pengutronix.de>
References: <1302039657-19395-1-git-send-email-adharmap@codeaurora.org>
 <20110426150746.GF3175@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110426150746.GF3175@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Tue, Apr 26, 2011 at 05:07:47PM +0200, Samuel Ortiz wrote:
> > - mfd_cell does not have platfrom_data anymore - use mfd data instead.
> I'm currently moving that away from the mfd_cell structure, in my for-next
> branch. mfd_cell now has a platform_data pointer back, and you should use
> mfd_get_cell() if you really need to reach the mfd_cell pointer (which you
> apparently don't). 
> Could you please generate patchs 3 and 4 against this branch ?
I just saw commit

	5828fdb (mfd: Use mfd cell platform_data for mc13xxx cells platform bits)

in next. It has a Cc: for me, but I didn't got it by mail.

Did you send a mail and it didn't reach me? Or maybe you just forgot to
send the mail out?

Anyhow, Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de> for
5828fdb, but I wonder if it's worth to add a new member to struct
platform_device for that to work.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
