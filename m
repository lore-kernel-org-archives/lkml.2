Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1BNKAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 05:00:49 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:60980 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab1BNKAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 05:00:45 -0500
Date: Mon, 14 Feb 2011 02:00:28 -0800
From: Andres Salomon <dilinger@queued.net>
To: dedekind1@gmail.com
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 09/17] t7166xb: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110214020028.2449dbe4@debxo>
In-Reply-To: <1297675064.2854.12.camel@localhost>
References: <20110211181101.3a4325e4@queued.net>
	<1297675064.2854.12.camel@localhost>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 11:17:44 +0200
Artem Bityutskiy <dedekind1@gmail.com> wrote:

> On Fri, 2011-02-11 at 18:11 -0800, Andres Salomon wrote:
> > No need to explicitly set the cell's platform_data/data_size.
> > 
> > Modify clients to use mfd_get_cell helper function instead of
> > accessing platform_data directly.
> 
> Wold it be possible to separate out MTD-related changes?
> 

It's possible, sure.  Patch 09 is the only one that touches
drivers/mtd.  It would introduce build and/or runtime problems if mtd
and mfd trees get out of synch, however.

I was hoping to get subsystem maintainer ACKs and run everything
through the mfd tree, if possible (though I haven't heard any feedback
from Samuel about any of this yet).
