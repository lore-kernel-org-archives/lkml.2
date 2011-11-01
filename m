Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab1KASKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:10:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46556 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753200Ab1KASKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:10:00 -0400
Date: Tue, 1 Nov 2011 18:09:57 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Taylor Hutt <thutt@chromium.org>
Cc: swarren@nvidia.com, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asoc: tegra: wm8903: Simplify pin disconnect
Message-ID: <20111101180957.GF10029@opensource.wolfsonmicro.com>
References: <1320164771-457-1-git-send-email-thutt@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320164771-457-1-git-send-email-thutt@chromium.org>
X-Cookie: Avoid reality at all costs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 09:26:11AM -0700, Taylor Hutt wrote:

> (Note that this patch fails the kernel patch checker because
>  the 'M' macro produces an error that it's value should be enclosed
>  in parenthesis; this is not actually possible for this use & expansion.)

So, this whole patch doesn't look like a Linux patch in either the code
itself or the way it's presented.  I remember having similar problems
before with patches you've submitted but this is even further off the
mark than previously.  I did start replying in detail but there's so
many really basic issues from the coding and patch submission style
level up that it was taking too long.

In general whenever you're modifying code (kernel or otherwise) if what
you're doing doesn't visually resemble the rest of the system there's
probably a problem.
