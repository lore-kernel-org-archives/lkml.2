Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab1BCJbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 04:31:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38475 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756002Ab1BCJbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 04:31:36 -0500
Date: Thu, 3 Feb 2011 09:31:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Timur Tabi <timur@freescale.com>,
        linux-input@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 12/19] twl4030: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110203093154.GC21591@opensource.wolfsonmicro.com>
References: <20110202195417.228e2656@queued.net>
 <20110202201522.72d37f1e@queued.net>
 <20110203060521.GA25739@core.coreip.homeip.net>
 <20110202223959.244b4a01@queued.net>
 <20110203065339.GA5592@core.coreip.homeip.net>
 <20110202230326.167fe873@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202230326.167fe873@queued.net>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 11:03:26PM -0800, Andres Salomon wrote:
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> > Then they are doing it incorrectly. One possible way is to have parent
> > device carry relevant data in its drvdata and have children get it
> > from there.

> I believe some drivers are even using the parent device already.  See
> drivers/leds/leds-mc13783.c, for example, whose parent device drvdata
> is used to pass around a struct mc13783 to its children.  Sounds
> like a possibility, will need to look into it further.

That's the current best practice approach.
