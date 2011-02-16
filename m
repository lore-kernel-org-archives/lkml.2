Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1BPRAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:00:52 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:59861 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab1BPRAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:00:50 -0500
Date: Wed, 16 Feb 2011 09:00:36 -0800
From: Andres Salomon <dilinger@queued.net>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 16/17] mc13xxx: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110216090036.6fffed34@debxo>
In-Reply-To: <20110216094154.GV13279@pengutronix.de>
References: <20110211181921.3d561568@queued.net>
	<20110216094154.GV13279@pengutronix.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011 10:41:54 +0100
Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:

> On Fri, Feb 11, 2011 at 06:19:21PM -0800, Andres Salomon wrote:
> > 
> > The cell's platform_data is now accessed with a helper function;
> > change clients to use that, and remove the now-unused data_size.
> > 
> > Note that mfd-core no longer makes a copy of platform_data, but the
> why was this changed and where?  I'm not able to find your complete
> series via gmane.

http://permalink.gmane.org/gmane.linux.kernel/1099164
I screwed up the threading, so the patches aren't underneath that
one.  Patchwork provides them nicely, though.

Here are the relevant patches:
https://patchwork.kernel.org/patch/551241/
https://patchwork.kernel.org/patch/551251/
https://patchwork.kernel.org/patch/551261/
..through
https://patchwork.kernel.org/patch/551451/

The next series is here:
http://thread.gmane.org/gmane.linux.kernel/1100514/focus=6046

