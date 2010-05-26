Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab0EZP62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:58:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34814 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756792Ab0EZP6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:58:25 -0400
Date: Wed, 26 May 2010 08:58:32 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
       Philippe R?tornaz <philippe.retornaz@epfl.ch>,
       linux-arm-kernel@lists.infradead.org, maramaopercheseimorto@gmail.com,
       sameo@linux.intel.com, s.hauer@pengutronix.de,
       linux-kernel@vger.kernel.org, valentin.longchamp@epfl.ch
Subject: Re: [PATCH 1/2] mc13783: add LED support
Message-ID: <20100526155831.GA18834@opensource.wolfsonmicro.com>
References: <1274114423-30020-1-git-send-email-philippe.retornaz@epfl.ch>
 <1274114423-30020-2-git-send-email-philippe.retornaz@epfl.ch>
 <20100517190242.GA17604@pengutronix.de>
 <20100517200017.GA25262@sirena.org.uk>
 <1274875268.24079.1.camel@rex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274875268.24079.1.camel@rex>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 01:01:08PM +0100, Richard Purdie wrote:
> On Mon, 2010-05-17 at 21:00 +0100, Mark Brown wrote:

> > It'd be nice to add helpers for this to the LED core, there's quite a
> > few drivers implementing this idiom now - a flag that does the deferring
> > of the set() for example.

> Agreed, or a wrapper around the core which deferred implementations
> could just use. I'm open to patches :)

In my copious free time, perhaps.  I was kind of hoping someone actively
working on a driver could be inspired to do the work :)
