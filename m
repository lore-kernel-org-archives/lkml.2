Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab0KVSC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 13:02:58 -0500
Received: from kroah.org ([198.145.64.141]:57716 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab0KVSC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 13:02:56 -0500
Date: Mon, 22 Nov 2010 09:53:32 -0800
From: Greg KH <greg@kroah.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Richard Purdie <rpurdie@linux.intel.com>, akpm <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de, stable@kernel.org
Subject: Re: [stable] [PATCH] backlight: grab ops_lock before testing
 bd->ops
Message-ID: <20101122175332.GC18808@kroah.com>
References: <1290418989-27653-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1290419947.1272.16677.camel@rex>
 <20101122100532.GA4693@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101122100532.GA4693@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 11:05:32AM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Mon, Nov 22, 2010 at 09:59:07AM +0000, Richard Purdie wrote:
> > On Mon, 2010-11-22 at 10:43 +0100, Uwe Kleine-König wrote:
> > > According to the comment describing ops_lock in the definition of
> > > struct backlight_device and when comparing with other functions in
> > > backlight.c the mutex must be hold when checking ops to be non-NULL.
> > > 
> > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > 
> > Acked-by: Richard Purdie <rpurdie@linux.intel.com>
> The problem was introduced by c835ee7f4154992e6cf0674d7ee136f5d36247a4
> (that is in 2.6.29-rc1).  Is this relevant for stable?

Yes.

What is the git commit id of the fix in Linus's tree?

thanks,

greg k-h
