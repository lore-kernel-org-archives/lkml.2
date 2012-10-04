Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425Ab2JDOMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 10:12:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53051 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933396Ab2JDOMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 10:12:08 -0400
Date: Thu, 4 Oct 2012 16:11:57 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <samuel.ortiz@linux.intel.com>
Cc: Fabio Estevam <festevam@gmail.com>, Marc Reilly <marc@cpdesign.com.au>,
        linux-arm-kernel@lists.infradead.org,
        "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/7] Add support for Freescale's mc34708 to mc13xxx driver
Message-ID: <20121004141157.GK598@pengutronix.de>
References: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <11987916.rOoNGcb1ly@dev1>
 <CAOMZO5AVP1L-6A7cmV-kQEfG1C+vczFKT=sQbFtLJDaGau0kRg@mail.gmail.com>
 <CAOMZO5BqZpy5Cz0BxbpdOY=sjMjhSOjfQZmJ4j7Xwe6Q7x6Yig@mail.gmail.com>
 <20121004135130.GC5554@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121004135130.GC5554@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 04, 2012 at 03:51:30PM +0200, Samuel Ortiz wrote:
> Did you send it to my samuel.ortiz@intel.com email ? I never look at it when
> going through my MFD backlog, which is why it was not applied. Which is why it
> won't be part of the 3.7 merge window, sorry about that.
I don't know why I picked that one up, but probably it's because this
address shows up in several commits:

	$ git log --grep=samuel.ortiz@intel.com | grep Samuel | sort | uniq -c
	     18     Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>
	     12 Author: Samuel Ortiz <sameo@linux.intel.com>
	     27 Author: Samuel Ortiz <samuel.ortiz@intel.com>
	      4     Cc: Samuel Ortiz <samuel.ortiz@intel.com>
	      1     Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
	     50     Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>

and one of these just happend to be the first I looked at.

hmm, *shrug*
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
