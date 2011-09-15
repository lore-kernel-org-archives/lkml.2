Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157Ab1IOQDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 12:03:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37658 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934081Ab1IOQDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 12:03:40 -0400
Date: Thu, 15 Sep 2011 18:03:21 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-arm-kernel@lists.infradead.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>, David Jander <david@protonic.nl>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        kernel@pengutronix.de, linux-input@vger.kernel.org
Subject: Re: [PATCH 0/6] mc13783 cleanup
Message-ID: <20110915160321.GA29357@pengutronix.de>
References: <20110824132740.GA28197@pengutronix.de>
 <201108250905.13168.philippe.retornaz@epfl.ch>
 <20110915151213.GE32263@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110915151213.GE32263@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Thu, Sep 15, 2011 at 05:12:13PM +0200, Samuel Ortiz wrote:
> On Thu, Aug 25, 2011 at 09:05:12AM +0200, Philippe Rétornaz wrote:
> > Le mercredi 24 août 2011 15:27:40, Uwe Kleine-König a écrit :
> > > Hello,
> > > 
> > > this series removes the long obsolte mc13783 API after fixing all
> > > remaining users.
> > 
> > I posted a patch last month which was touching this MFD too.
> > We will need to synchronize both patch. 
> I applied Uwe's patchset now.
Thanks.

>                               Could you please sync your code and send me a
> patchset that applies on top of:
> 
> git://git.infradead.org/users/sameo/mfd-2.6.git for-next
You can fetch the updated series from

	git://git.pengutronix.de/git/ukl/linux-2.6.git mc13783

I also included the last patch that Sascha commented with:

	Please ping once the rest is merged.

This is OK as I'm currently substituting Sascha for imx maintainer
duties while he is on vacation. Merging the above branch into the
current imx/for-next branch yields a merge conflict in
drivers/rtc/rtc-twl.c which is only touched on your side and in Linus'
tree below imx/for-next.

I guess you can drop 54d96ef785b5 as it is the same as dec35d19c4 +
34d623d.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
