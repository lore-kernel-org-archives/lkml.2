Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab1JQNzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 09:55:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59858 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755841Ab1JQNzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 09:55:11 -0400
Date: Mon, 17 Oct 2011 14:55:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, zdevai@gmail.com
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
Message-ID: <20111017135508.GE27266@opensource.wolfsonmicro.com>
References: <20111017101959.GC3042@opensource.wolfsonmicro.com>
 <4E9C0423.5010909@cam.ac.uk>
 <20111017104642.GD3042@opensource.wolfsonmicro.com>
 <4E9C0DD7.7080105@cam.ac.uk>
 <20111017111807.GA27266@opensource.wolfsonmicro.com>
 <4E9C1249.5020408@cam.ac.uk>
 <20111017120813.GB27266@opensource.wolfsonmicro.com>
 <4E9C201D.30905@cam.ac.uk>
 <20111017124807.GD27266@opensource.wolfsonmicro.com>
 <4E9C27B9.50504@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9C27B9.50504@cam.ac.uk>
X-Cookie: Be cautious in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 02:03:53PM +0100, Jonathan Cameron wrote:
> On 10/17/11 13:48, Mark Brown wrote:

> >> 0...4
> >> 1...5
> >> AUXA....AUXD
> >> TEMP_EXT1...TEMP_EXT5 (all of which are just normal adc channels that some
> >> designer decided would be used only for connecting analog temperature sensors.)

> > None of those look at all unreasonable

> Fair enough though the temp one is at least stupid, but why should
> we match them?

So that the engineer sitting there with the schematics can figure out
how to tell software about the board hookup with minimal pain.

> Ok, so we could add to every channel a magic matching field called
> datasheet_name?  To my mind its silly overhead, but if there is a
> consensus on it then fine.  Note however that any remotely general
> purpose userspace will not read these values even if we make
> them available.

That depends, if the userspace is really general purpose I'd expect it'd
be exposing this information to let the user point and click (or
whatever) through the channels.  Otherwise they'll be scratching their
heads wondering what channel 0 on this particular system actually is.
