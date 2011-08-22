Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1HVWfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 18:35:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47771 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754007Ab1HVWfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 18:35:39 -0400
Date: Mon, 22 Aug 2011 23:35:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sound/soc/mxs/mxs-saif.c: add missing kfree
Message-ID: <20110822223535.GD29473@opensource.wolfsonmicro.com>
References: <1313820761-12042-3-git-send-email-julia@diku.dk>
 <20110820134439.GA2266@pengutronix.de>
 <Pine.LNX.4.64.1108201718200.30651@ask.diku.dk>
 <65EE16ACC360FA4D99C96DC085B3F7722212DF@039-SN1MPN1-001.039d.mgd.msft.net>
 <Pine.LNX.4.64.1108211318060.4072@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108211318060.4072@ask.diku.dk>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 01:18:45PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Move the test on pdev->id before the kzalloc to avoid requiring kfree when
> the test fails.  This fix was suggested by Wolfram Sang.
> 

Applied, thanks.
