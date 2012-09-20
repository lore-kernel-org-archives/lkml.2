Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab2ITXyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:54:31 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:54429 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754980Ab2ITXya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:54:30 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+x0hzP5dSo8WQZIMu6BfYM
Date: Thu, 20 Sep 2012 16:54:24 -0700
From: Tony Lindgren <tony@atomide.com>
To: Olof Johansson <olof@lixom.net>
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers: bus: Move the OMAP interconnect driver to
 drivers/bus/
Message-ID: <20120920235423.GP28835@atomide.com>
References: <1347614434-15938-1-git-send-email-santosh.shilimkar@ti.com>
 <20120917215128.GF11762@atomide.com>
 <201209191857.57862.arnd@arndb.de>
 <CAMQu2gw0AmVhW+qR9GUGkUd2G+aZd9A=skTUDJiY2BMpURmSNQ@mail.gmail.com>
 <CAOesGMgzAiFQKpZEpXqRS+U9fxcLAemhb+MCNsn0AOffa6JiNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgzAiFQKpZEpXqRS+U9fxcLAemhb+MCNsn0AOffa6JiNA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Olof Johansson <olof@lixom.net> [120920 16:23]:
> On Wed, Sep 19, 2012 at 10:56 PM, Shilimkar, Santosh
> <santosh.shilimkar@ti.com> wrote:
> > On Thu, Sep 20, 2012 at 12:27 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> On Monday 17 September 2012, Tony Lindgren wrote:
> >>> * Santosh Shilimkar <santosh.shilimkar@ti.com> [120914 02:21]:
> >>> > OMAP interconnect drivers are used for the interconnect error handling.
> >>> > Since they are bus driver, lets move it to newly created drivers/bus.
> >>> >
> >>> > Cc: Arnd Bergmann <arnd@arndb.de>
> >>> > Cc: Tony Lindgren <tony@atomide.com>
> >>> > Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
> >>> > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> >>> > ---
> >>> > Patch just moves OMAP interconnect drivers as is to the newly created
> >>> > driver/bus/* directory. Patch is generated against "arm-soc/drivers/ocp2scp"
> >>> > tree and test on all OMAP boards.
> >>>
> >>> Great, looks like this should not conflict with other
> >>> omap patches queued, so Arnd should probably take this into
> >>> the bus branch:
> >>>
> >>> Acked-by: Tony Lindgren <tony@atomide.com>
> >>
> >> It turns out that the patch actually did conflict and we now have a broken
> >> omap2plus_defconfig. The patch below seems to fix it, but please verify
> >> that this makes sense.
> >>
> >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >>
> > Looks correct.
> >
> > Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> I ended up applying something very similar to this and carried the
> ACKs on that, but I broke it up in two pieces; one for the
> drivers/ocp2scp branch to fix the irq numbers, and another to just
> for-next to deal with the soc.h include file (since that should
> probably have been fixed at branch merge time).
> 
> Pushed out to for-next as well.

OK thanks!

Tony
