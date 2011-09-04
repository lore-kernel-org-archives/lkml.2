Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab1IDP5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 11:57:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50480 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751026Ab1IDP50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 11:57:26 -0400
Date: Sun, 4 Sep 2011 08:57:22 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/8] regmap: Introduce caching support
Message-ID: <20110904155722.GD21528@opensource.wolfsonmicro.com>
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1314978375-11539-2-git-send-email-dp@opensource.wolfsonmicro.com>
 <4E61363A.9050607@metafoo.de>
 <20110902234827.GA31813@opensource.wolfsonmicro.com>
 <20110903011032.GA10060@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110903011032.GA10060@opensource.wolfsonmicro.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 03, 2011 at 02:10:32AM +0100, Dimitris Papastamos wrote:
> On Sat, Sep 03, 2011 at 12:48:27AM +0100, Mark Brown wrote:
> > On Fri, Sep 02, 2011 at 10:02:02PM +0200, Lars-Peter Clausen wrote:

> > > It should be OK to provide no default register values, in this case regmap
> > > should assume that the default for all registers is 0.

> > Yes - Dimitris, as we discussed offline it's pretty much essential for
> > things like PMICs where the defaults aren't meaningful and may even be

> That's implemented in patch 8/8.  I can of course squash that patch into
> the other patch.

Ah, good - I was a bit surprised as I did remember discussing this with
you.  Please do move that code into the intial patch, in general it's
usually OK to miss features out of early patches or simplify them but
making them actively buggy isn't great.
