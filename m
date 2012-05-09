Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635Ab2EIINQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:13:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37594 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2EIINM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:13:12 -0400
Date: Wed, 9 May 2012 10:13:06 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Christoph Fritz <chf.fritz@googlemail.com>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Hans J. Koch" <hjk@hansjkoch.de>, Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH] ARM: mx35: add cpufreq support
Message-ID: <20120509081306.GK27341@pengutronix.de>
References: <20120507141437.GA9636@lovely.krouter>
 <20120509072239.GG27341@pengutronix.de>
 <20120509075618.GA4412@lovely.krouter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509075618.GA4412@lovely.krouter>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:03:17 up 178 days, 15:50, 66 users,  load average: 0.09, 0.13,
 0.14
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 09:56:18AM +0200, Christoph Fritz wrote:
> Hi Sascha,
> 
> On Wed, May 09, 2012 at 09:22:39AM +0200, Sascha Hauer wrote:
> > On Mon, May 07, 2012 at 04:14:37PM +0200, Christoph Fritz wrote:
> > > This patch adds the mx35 to the supported cpu-families of the
> > > "CPUfreq driver for i.MX CPUs".
> > 
> > I'm afraid this has to wait another cycle since you are patching a file
> > that is scheduled to be replaced with common clock framework support.
> 
> Has this "scheduled replacement" somewhere (e.g. calendar) been
> marked? So that I can check in the future before editing "scheduled
> files".

The clock framework conversion has been a hot topic for quite a while
now, but there hasn't been an official note about it outside the list.
I can understand that the occasional linux arm kernel reader is not
aware of it, but we currently have nothing in place to anounce such
things. (Other than feature-removal.txt which seems not very suitable
since no feature is removed, only updated)

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
