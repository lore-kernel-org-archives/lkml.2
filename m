Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab2JEVeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 17:34:24 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48503 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab2JEVeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 17:34:20 -0400
Date: Fri, 5 Oct 2012 17:34:54 -0400
From: Matt Porter <mporter@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, gururaja.hebbar@ti.com,
        Sekhar Nori <nsekhar@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alsa Devel List <alsa-devel@alsa-project.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>,
        Daniel Mack <zonque@gmail.com>
Subject: Re: [PATCH 0/2] Convert davinci ASoC to genalloc SRAM
Message-ID: <20121005213454.GO11149@beef>
References: <1349345745-10584-1-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349345745-10584-1-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 06:15:43AM -0400, Matt Porter wrote:
> This series converts davinci ASoC to use genalloc and enables
> that support on DA850. It applies on top of the uio_pruss/genalloc
> series [1] which allows DaVinci to provide a gen_pool via pdata
> for driver use.
> 
> I've tested this on the AM180x EVM. Note that prior to this,
> the SRAM paths in the driver were completely unused. I've only
> enabled ping-pong buffering on the platform I can test as it's
> best to allow those with DM644x and similar platforms to set the
> playback/capture sram size to something that's known to work
> for them.
> 
> [1] http://www.spinics.net/lists/arm-kernel/msg198854.html

Tested again on top of v4 of the uio_pruss/genalloc series
http://www.spinics.net/lists/arm-kernel/msg199255.html
on next-20121005 since there's some conflicts falling out of
of arm-soc and asoc/sound header move patches on mainline 
atm.

-Matt
