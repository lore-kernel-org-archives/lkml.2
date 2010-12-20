Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab0LTKwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 05:52:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55584 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754833Ab0LTKwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 05:52:05 -0500
Date: Mon, 20 Dec 2010 10:52:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (mfd
 tree related)
Message-ID: <20101220105202.GA26706@rakim.wolfsonmicro.main>
References: <20101220192121.47767525.sfr@canb.auug.org.au>
 <20101220103336.GC11095@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220103336.GC11095@sortiz-mobl>
X-Cookie: Reapply as necessary.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 11:33:37AM +0100, Samuel Ortiz wrote:
> On Mon, Dec 20, 2010 at 07:21:21PM +1100, Stephen Rothwell wrote:

> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:

> Ok, I removed Mark's commit, the MFD tree should build fine now.
> I'm keeping this one for whenever we'll have a proper pwm framework.

It doesn't need dropping I think, the driver should just need a
dependency on HAVE_PWM adding.
