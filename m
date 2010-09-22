Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab0IVPjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:39:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59105 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750739Ab0IVPjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:39:46 -0400
Date: Wed, 22 Sep 2010 16:39:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100922153944.GH26395@rakim.wolfsonmicro.main>
References: <20100920140049.31408.67527.stgit@localhost.localdomain>
 <20100920150431.GD31167@sirena.org.uk>
 <20100920152726.68ac2d84@linux.intel.com>
 <20100920152705.GJ3414@rakim.wolfsonmicro.main>
 <AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
 <1285168933.4498.119.camel@i7.infradead.org>
 <20100922153321.GD32476@sirena.org.uk>
 <1285169717.4498.121.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285169717.4498.121.camel@i7.infradead.org>
X-Cookie: Do students of Zen Buddhism do Om-work?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 04:35:17PM +0100, David Woodhouse wrote:
> On Wed, 2010-09-22 at 16:33 +0100, Mark Brown wrote:

> > This is roughly what it's doing except that it's going to native Linux
> > bus types and platform data rather than to device tree.

> It still means that drivers for chips which are seen both on this
> bizarre abomination and also on other machines which use a device-tree
> will need to support *both* probe types.

No, the drivers don't see any of this but instead someone has to
write (and maintain) explicit code to do the translation in arch/x86
outside the drivers.  The drivers just see platform data and regular bus
probes which they'll be doing anyway until such time as device tree is
well enough established for people to stop doing platform data.
