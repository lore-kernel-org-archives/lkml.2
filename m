Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1LTCR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 21:17:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56644 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253Ab1LTCR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 21:17:27 -0500
Date: Tue, 20 Dec 2011 02:17:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v4 3/4] regulator: simplify twl4030 config
Message-ID: <20111220021722.GA8257@opensource.wolfsonmicro.com>
References: <1324343717-7292-1-git-send-email-felipe.contreras@gmail.com>
 <1324343717-7292-4-git-send-email-felipe.contreras@gmail.com>
 <20111220011923.GS2860@opensource.wolfsonmicro.com>
 <CAMP44s1XFo0_O-pGMNO7m=weXuCpXzS8oH6m6PaPNzLGRQpDgA@mail.gmail.com>
 <20111220015316.GW2860@opensource.wolfsonmicro.com>
 <CAMP44s3iSVEbghx9nGU-w9N+Bsdw040=UQtiw6RRyq021ssBxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP44s3iSVEbghx9nGU-w9N+Bsdw040=UQtiw6RRyq021ssBxw@mail.gmail.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 04:04:14AM +0200, Felipe Contreras wrote:
> On Tue, Dec 20, 2011 at 3:53 AM, Mark Brown

> > Yes, of course.  Half the point in having subsystems and standard ways
> > of doing things is so that when we look at things we've got a reasonable
> > idea as to what they're supposed to be doing and people looking at the
> > code can figure out what's going on.   We don't want people to have to
> > play guessing games about this stuff.

> Of course... *ideally*, but we are not there right now.

We pretty much were, but this patch has changelog which says "I've got a
cool new way of doing things for this one driver!" which clearly applies
to other drivers.  I wouldn't mind a patch which does this for all MFDs
(though I really do think it should be applied to most subsystems) but
doing it for one driver isn't great.
