Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab0EZMG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:06:58 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:60538 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab0EZMG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:06:57 -0400
Subject: Re: [PATCH 1/2] mc13783: add LED support
From: Richard Purdie <rpurdie@rpsys.net>
To: Philippe =?ISO-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
Cc: Daniel Mack <daniel@caiaq.de>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "maramaopercheseimorto@gmail.com" <maramaopercheseimorto@gmail.com>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Longchamp Valentin <valentin.longchamp@epfl.ch>
In-Reply-To: <201005251706.54665.philippe.retornaz@epfl.ch>
References: <1274114423-30020-1-git-send-email-philippe.retornaz@epfl.ch>
	 <201005181327.29529.philippe.retornaz@epfl.ch>
	 <20100525145759.GJ30801@buzzloop.caiaq.de>
	 <201005251706.54665.philippe.retornaz@epfl.ch>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 13:03:20 +0100
Message-ID: <1274875400.24079.2.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 17:06 +0200, Philippe Rétornaz wrote:
> Le mardi, 25 mai 2010 16.57:59, Daniel Mack a écrit :
> > On Tue, May 18, 2010 at 01:27:29PM +0200, Philippe Rétornaz wrote:
> > > Thank you for the review, I will post a v2 patch with the appropriates
> > > fixes soon.
> > 
> > Just curious - is there a v2 of this patches coming?
> > 
> 
> It has been posted the 19 May 2010. I'm sorry, I forgot to put you in CC.
> http://lists.infradead.org/pipermail/linux-arm-kernel/2010-May/015777.html
> 
> BTW, what is the merge status of thoses patches ?

The patch looks reasonable to me so I've queued them both in the leds
tree since its more an LED change than any of the other subsystems.

Cheers,

Richard

