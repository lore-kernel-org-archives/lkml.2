Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab0KWI4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:56:46 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36030 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab0KWI4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:56:45 -0500
Date: Tue, 23 Nov 2010 09:56:35 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: Richard Purdie <rpurdie@linux.intel.com>, akpm <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de, stable@kernel.org
Subject: Re: [stable] [PATCH] backlight: grab ops_lock before testing
	bd->ops
Message-ID: <20101123085635.GH4693@pengutronix.de>
References: <1290418989-27653-1-git-send-email-u.kleine-koenig@pengutronix.de> <1290419947.1272.16677.camel@rex> <20101122100532.GA4693@pengutronix.de> <20101122175332.GC18808@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101122175332.GC18808@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, Nov 22, 2010 at 09:53:32AM -0800, Greg KH wrote:
> On Mon, Nov 22, 2010 at 11:05:32AM +0100, Uwe Kleine-König wrote:
> > Hello,
> > 
> > On Mon, Nov 22, 2010 at 09:59:07AM +0000, Richard Purdie wrote:
> > > On Mon, 2010-11-22 at 10:43 +0100, Uwe Kleine-König wrote:
> > > > According to the comment describing ops_lock in the definition of
> > > > struct backlight_device and when comparing with other functions in
> > > > backlight.c the mutex must be hold when checking ops to be non-NULL.
> > > > 
> > > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > 
> > > Acked-by: Richard Purdie <rpurdie@linux.intel.com>
> > The problem was introduced by c835ee7f4154992e6cf0674d7ee136f5d36247a4
> > (that is in 2.6.29-rc1).  Is this relevant for stable?
> 
> Yes.
> 
> What is the git commit id of the fix in Linus's tree?
I'll let you know when it hits his tree.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
