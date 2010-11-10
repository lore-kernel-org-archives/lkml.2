Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab0KJPS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:18:56 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42203 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab0KJPSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:18:54 -0500
Date: Wed, 10 Nov 2010 15:18:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: saeed bishara <saeed.bishara@gmail.com>
Cc: Alexey Charkov <alchark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v4] ARM: Add basic architecture support for
	VIA/WonderMedia 85xx SoC's
Message-ID: <20101110151801.GC24305@n2100.arm.linux.org.uk>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com> <20101107165745.GB1759@n2100.arm.linux.org.uk> <AANLkTimFJ=Brx4pDiUqZOKDfABaDg0s_yFC7EkZGi7D8@mail.gmail.com> <20101107171726.GF1759@n2100.arm.linux.org.uk> <20101108171930.GA1471@alchark-u3s.lan> <AANLkTinqpP8WN2h-kR7svZ6GZxi+0RMPBfPyMnzCpAuO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinqpP8WN2h-kR7svZ6GZxi+0RMPBfPyMnzCpAuO@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 05:16:17PM +0200, saeed bishara wrote:
> > diff --git a/arch/arm/mach-vt8500/include/mach/uncompress.h b/arch/arm/mach-vt8500/include/mach/uncompress.h
> > new file mode 100644
> > index 0000000..bb9e2d2
> > --- /dev/null
> > +++ b/arch/arm/mach-vt8500/include/mach/uncompress.h
> > @@ -0,0 +1,37 @@
> > +/* arch/arm/mach-vt8500/include/mach/uncompress.h
> > + *
> > + * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
> > + *
> > + * Based on arch/arm/mach-dove/include/mach/uncompress.h
> please  replace dove with vt8500

That doesn't make sense - how can a file be created, based upon itself?
