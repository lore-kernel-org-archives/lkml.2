Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab0LNVvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:51:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38335 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751008Ab0LNVvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:51:14 -0500
Date: Tue, 14 Dec 2010 21:51:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier@gentoo.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH] gpiolib: Convert ADP5588 to new irq_ APIs
Message-ID: <20101214215112.GA25106@opensource.wolfsonmicro.com>
References: <1292159988-28268-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20101214124332.07f2a212.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214124332.07f2a212.akpm@linux-foundation.org>
X-Cookie: Courage is your greatest present need.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 12:43:32PM -0800, Andrew Morton wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > The genirq core is being updated to pass struct irq_data to irq_chip
> > operations instead of an irq number. Update the ADP5588 GPIO driver to
> > the new API.

> Seems to be the same as Lennert's patch, except he called it "d"?

Yes, we're both doing the same conversions - I posted this one patch for
the gpio stuff over the weekend then Lennart posted his on Monday.
There's no meaningful difference between the two of them, so long as one
of them gets in it's all good.
