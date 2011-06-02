Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab1FBPra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 11:47:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55067 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab1FBPr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 11:47:29 -0400
Date: Thu, 2 Jun 2011 16:47:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd wm8350: allocate irq descs dynamically
Message-ID: <20110602154726.GB4253@sirena.org.uk>
References: <20110602114502.GO23771@pengutronix.de> <20110602115349.GF3085@opensource.wolfsonmicro.com> <20110602133743.GA4253@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602133743.GA4253@sirena.org.uk>
X-Cookie: Wanna buy a duck?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 02:37:44PM +0100, Mark Brown wrote:

> Actually I take that back, it looks like the wm831x equivalent patch is
> causing some sort of semi-intermittent issue with the IRQ infrastructure
> on non-sparse systems so I suspect this patch is also problematic.  The
> major symptom is lockups in softirq handling.

I figured this out - it's not an issue with this code so I reinstate my
ack, sorry for the noise!
