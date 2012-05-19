Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177Ab2ESENN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 00:13:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56679 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2ESENL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 00:13:11 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpiolib: quiet gpiochip_add boot message noise
To: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linus.walleij@stericsson.com
In-Reply-To: <201205111658.33327.hartleys@visionengravers.com>
References: <201205111658.33327.hartleys@visionengravers.com>
Date: Fri, 18 May 2012 22:13:09 -0600
Message-Id: <20120519041309.183D73E046E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012 16:58:33 -0700, H Hartley Sweeten <hartleys@visionengravers.com> wrote:
> The pr_info message in gpiochip_add gets displayed for every
> gpiochip registered. When first bringing up a system this
> information could be helpful but for normal use it's just a
> bunch of noise. Change the message to a pr_debug.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@stericsson.com>

Applied, thanks.

g.

