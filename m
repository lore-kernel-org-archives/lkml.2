Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760719Ab0J0KXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:23:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47906 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab0J0KW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:22:58 -0400
Date: Wed, 27 Oct 2010 11:22:53 +0100
From: Grant Likely <grant.likely@secretlab.ca>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
        amit.kucheria@canonical.com
Subject: Re: [PATCH] ARM: imx: Add some core definitions for MX53
Message-ID: <20101027102253.GA7822@angua.secretlab.ca>
References: <1288119235-7036-1-git-send-email-Dinh.Nguyen@freescale.com>
 <20101027082958.GA6797@angua.secretlab.ca>
 <20101027090921.GB8554@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101027090921.GB8554@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 11:09:21AM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> On Wed, Oct 27, 2010 at 09:29:59AM +0100, Grant Likely wrote:
> > > ---
> > >  arch/arm/plat-mxc/include/mach/iomux-mx53.h |  301 +++++++++++++++++++
> > >  arch/arm/plat-mxc/include/mach/mx53.h       |  433 +++++++++++++++++++++++++++
> > 
> > Hi Dinh.
> > 
> > In general, these definitions should not be added until they are
> > actually needed by driver code.
> ack.
> 
> > Also, from my understanding, the mx53 is very similar to the mx51.
> > If I'm correct, then they should be sharing the same set of #defines.
> Note, I asked for a seperate header file.  See
> http://thread.gmane.org/gmane.linux.kernel/1051001/focus=1051352

For the record, I disagree with that approach.  The approach I would
take is for the imx53 code to use the imx51 defines by default, and to
only define imx53 variants where there are differences.  Otherwise the
code to support imx53 has to be completely divergent from imx51
because the defines are different symbols.

g.

