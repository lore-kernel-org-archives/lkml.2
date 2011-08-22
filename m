Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab1HVW36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 18:29:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43324 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754139Ab1HVW34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 18:29:56 -0400
Date: Mon, 22 Aug 2011 23:29:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Liam Girdwood <lrg@ti.com>, kernel-janitors@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Alexander Sverdlin <subaparts@yandex.ru>,
        Ryan Mallon <rmallon@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] sound/soc/ep93xx/ep93xx-i2s.c: add missing kfree
Message-ID: <20110822222953.GC30609@opensource.wolfsonmicro.com>
References: <1313820761-12042-2-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313820761-12042-2-git-send-email-julia@diku.dk>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 08:12:39AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Introduce a new label that includes kfree and jump to that one.

Applied, thanks.
