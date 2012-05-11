Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248Ab2EKXyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:54:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52354 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759610Ab2EKXyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:54:05 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpiolib: quiet gpiochip_add boot message noise
To: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linus.walleij@stericsson.com
In-Reply-To: <201204131738.34500.hartleys@visionengravers.com>
References: <201204131738.34500.hartleys@visionengravers.com>
Date: Fri, 11 May 2012 17:54:03 -0600
Message-Id: <20120511235403.E7FED3E0791@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012 17:38:34 -0700, H Hartley Sweeten <hartleys@visionengravers.com> wrote:
> The pr_info message in gpiochip_add gets displayed for every
> gpiochip registered. When first bringing up a system this
> information could be helpful but for normal use it's just a
> bunch of noise. Change the message to a pr_debug.
> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@stericsson.com>

No s-o-b?

g.

