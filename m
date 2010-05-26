Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab0EZL57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:57:59 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:60437 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab0EZL55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:57:57 -0400
Subject: Re: [PATCH 3/3] gta02: Use pcf50633 backlight driver instead of
 platform backlight driver.
From: Richard Purdie <rpurdie@rpsys.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Lars-Peter Clausen <lars@metafoo.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100516220010.GA3236@sortiz.org>
References: <1273625074-15312-1-git-send-email-lars@metafoo.de>
	 <1273625074-15312-4-git-send-email-lars@metafoo.de>
	 <20100512010211.GL2589@trinity.fluff.org> <1273760705.12731.12.camel@rex>
	 <20100516220010.GA3236@sortiz.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 12:57:35 +0100
Message-ID: <1274875055.24079.0.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 00:00 +0200, Samuel Ortiz wrote:
> On Thu, May 13, 2010 at 10:25:05PM +0800, Richard Purdie wrote:
> > On Wed, 2010-05-12 at 02:02 +0100, Ben Dooks wrote:
> > > On Wed, May 12, 2010 at 02:44:34AM +0200, Lars-Peter Clausen wrote:
> > > > Use the pcf50633 backlight driver instead of the platform backlight driver.
> > > > 
> > > > Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> > > > Cc: Ben Dooks <ben-linux@fluff.org>
> > > 
> > > ok, does anyone else have a comment on this?
> > 
> > Looks like a sensible idea to me but I'm travelling and don't have time
> > to properly review the patches right now.
> > 
> > The main question is who takes which patches. I can take the main new
> > backlight one, the other two I need opinions from the mfd (Samuel) and
> > gta02 (?) maintainers...
> The MFD patch looks good to me, you can add my:
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Thanks, I've queued these in the backlight tree.

Cheers,

Richard

