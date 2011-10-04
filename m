Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab1JDK6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 06:58:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43067 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756077Ab1JDK63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 06:58:29 -0400
Date: Tue, 4 Oct 2011 11:58:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: Add WM1811 support
Message-ID: <20111004105827.GF3250@opensource.wolfsonmicro.com>
References: <1317149407-27635-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20111004101902.GV4118@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004101902.GV4118@sortiz-mobl>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 12:19:02PM +0200, Samuel Ortiz wrote:
> On Tue, Sep 27, 2011 at 07:50:05PM +0100, Mark Brown wrote:

> > Due to the ASoC cross dependencies it seems like it'll be easier to
> > merge this via ASoC - Samuel, does this make sense to you?

> It does.
> Liam, please add my:
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Hrm, actually there's a bit of overlap with "mfd: Add more checks for
WM8994 being active during suspend" from your tree.  It's only a one
line change (adding the WM1811 device ID) so I don't see any problem
with just applying that during -rc, or I could cherry-pick that change
over now?  Anyway, I've applied the patch just now.
