Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab0GOI7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 04:59:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44996 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932652Ab0GOI7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 04:59:35 -0400
Date: Thu, 15 Jul 2010 09:59:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Tejun Heo <tj@kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 0/12] sound/alsa/soc/codec: fix memory leak and
 resource relaim in error path
Message-ID: <20100715085932.GA23529@rakim.wolfsonmicro.main>
References: <1279162147.29294.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279162147.29294.2.camel@mola>
X-Cookie: There's only one everything.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 10:49:07AM +0800, Axel Lin wrote:

> [PATCH 1/12] ad1836: fix a memory leak if another ad1836 is registered
> [PATCH 2/12] ak4642: fix a memory leak if failed to initialise AK4642
> [PATCH 3/12] da7210: fix a memory leak if failed to initialise da7210 audio codec
> [PATCH 4/12] wm8523: fix resource reclaim in wm8523_register error path
> [PATCH 5/12] wm8711: fix a memory leak if another WM8711 is registered
> [PATCH 6/12] wm8904: fix resource reclaim in wm8904_register error path
> [PATCH 7/12] wm8940: fix resource reclaim in wm8940_register error path
> [PATCH 8/12] wm8955: fix resource reclaim in wm8955_register error path
> [PATCH 9/12] wm8961: fix resource reclaim in wm8961_register error path
> [PATCH 10/12] wm8974: fix a memory leak if another WM8974 is registered
> [PATCH 11/12] wm8978: fix a memory leak if another WM8978 is registered
> [PATCH 12/12] wm9081: fix resource reclaim in wm9081_register error path

If you're going to be submiting large batches of small patches like this
it would be really helpful if you could make sure you format the subject
lines for your patches so that they match the standards for the area of
the kernel you're updating.  This makes them much easier to apply.
