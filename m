Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab2DGHLa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 03:11:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59970 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2DGHKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 03:10:41 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] gpiolib: Implement devm_gpio_request_one()
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20120406144917.GE19424@opensource.wolfsonmicro.com>
References: <1333552489-27694-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1333552489-27694-2-git-send-email-broonie@opensource.wolfsonmicro.com> <20120406044832.7C80D3E0ED5@localhost> <20120406144917.GE19424@opensource.wolfsonmicro.com>
Date: Fri, 06 Apr 2012 19:25:12 -0700
Message-Id: <20120407022512.2C65C3E1B12@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012 15:49:17 +0100, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Apr 05, 2012 at 09:48:32PM -0700, Grant Likely wrote:
> 
> > Can we make devm_gpio_request a static inline wrapper around
> > devm_gpio_request_one() with the flags field set to '0'?  I don't liek
> > the duplication of this function.
> 
> > Similarily, gpio_request() should actually be a static inline around
> > gpio_request_one() instead of the other way around as it is currently
> > written.
> 
> Yeah, I couldn't understand why the non-managed functions were written
> in this way so I followed the same pattern when I added the managed one
> assuming that the original code was sane.

Actually, I looked at it again, and the _one version behaves subtly
different from the non-_one version.  That may be irrelevant though.

g.


-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
