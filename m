Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab2AUSoA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:44:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35444 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848Ab2AUSn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:43:59 -0500
Date: Sat, 21 Jan 2012 18:43:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 4/14] kernel-doc: fix new warning in regulator core
Message-ID: <20120121184356.GH10751@opensource.wolfsonmicro.com>
References: <4F1B0BCE.4050505@xenotime.net>
 <20120121183512.GF10751@opensource.wolfsonmicro.com>
 <4F1B140F.8080408@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1B140F.8080408@xenotime.net>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 11:37:51AM -0800, Randy Dunlap wrote:
> On 01/21/2012 10:35 AM, Mark Brown wrote:

> > Please don't apply this, I can't actually parse that description so I'm
> > fairly sure users will struggle also.  I'll try to get round to writing
> > something better at some point.

> Thanks.  Ah, 'of' is not the preposition above, it was meant to be
> the acronym for open firmware.  :(

Ah!  Now it parses fine!  Should still be clarified though, I'm sure
other people will make the same mistake, and actually the reason it's a
parameter is that it often won't actually be a device but will instead
be some named subnode.

Like I say I'll try to get round to fixing this.
