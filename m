Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab0EMOgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 10:36:10 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:56080 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab0EMOgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 10:36:05 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 May 2010 10:36:05 EDT
Subject: Re: [PATCH 3/3] gta02: Use pcf50633 backlight driver instead of
 platform backlight driver.
From: Richard Purdie <rpurdie@linux.intel.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, sameo@linux.intel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100512010211.GL2589@trinity.fluff.org>
References: <1273625074-15312-1-git-send-email-lars@metafoo.de>
	 <1273625074-15312-4-git-send-email-lars@metafoo.de>
	 <20100512010211.GL2589@trinity.fluff.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 22:25:05 +0800
Message-ID: <1273760705.12731.12.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 02:02 +0100, Ben Dooks wrote:
> On Wed, May 12, 2010 at 02:44:34AM +0200, Lars-Peter Clausen wrote:
> > Use the pcf50633 backlight driver instead of the platform backlight driver.
> > 
> > Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> > Cc: Ben Dooks <ben-linux@fluff.org>
> 
> ok, does anyone else have a comment on this?

Looks like a sensible idea to me but I'm travelling and don't have time
to properly review the patches right now.

The main question is who takes which patches. I can take the main new
backlight one, the other two I need opinions from the mfd (Samuel) and
gta02 (?) maintainers...

Cheers,

Richard



