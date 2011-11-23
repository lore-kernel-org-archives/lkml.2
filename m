Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab1KWK3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:29:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35517 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752165Ab1KWK3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:29:41 -0500
Date: Wed, 23 Nov 2011 10:29:34 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound: drop support for PlayPaq with WM8510
Message-ID: <20111123102933.GI4332@opensource.wolfsonmicro.com>
References: <1322041150.1753.25.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322041150.1753.25.camel@x61.thuisdomein>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 10:39:10AM +0100, Paul Bolle wrote:
> SoC Audio support for PlayPaq with WM8510 got added in commit 9aaca9683b
> ("[ALSA] Revised AT32 ASoC Patch"). That support depends on
> BOARD_PLAYPAQ. That Kconfig symbol didn't exist when that support got
> added in v2.6.27. It still doesn't. It has never been possible to even
> build this driver. Drop it.

Applied, thanks.  Please do always use subject lines which match the
subsystem you're submitting against.
