Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab0DBQJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 12:09:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60337 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751222Ab0DBQI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 12:08:57 -0400
Date: Fri, 2 Apr 2010 17:08:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/17] mfd: update gfp/slab.h includes
Message-ID: <20100402160855.GA15928@rakim.wolfsonmicro.main>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
 <1269885165-18617-13-git-send-email-tj@kernel.org>
 <20100402101159.GC8010@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402101159.GC8010@sortiz.org>
X-Cookie: optimist, n:
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 12:12:00PM +0200, Samuel Ortiz wrote:
> Hi Tejun,
> 
> On Tue, Mar 30, 2010 at 02:52:40AM +0900, Tejun Heo wrote:
> > Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> > gfp.h or slab.h is included as necessary.
> The davinci MFD driver is sitting in Mark's tree, so I guess he should take
> this patch.
> Mark, feel free to add my:
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>

> to this patch.

Unfortunately drivers/gpio/rdc321x-gpio.c isn't in mainline yet so the
patch doesn't apply cleanly to ASoC either.  I've applied the DaVinci
hunk, the other will need to go via your tree.
