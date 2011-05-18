Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab1ERQiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:38:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46184 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932849Ab1ERQiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:38:19 -0400
Date: Wed, 18 May 2011 09:38:19 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Taylor Hutt <thutt@chromium.org>
Cc: Peter Hsiang <peter.hsiang@maxim-ic.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Max98095: Move existing NULL check before pointer
 dereference.
Message-ID: <20110518163819.GD16414@opensource.wolfsonmicro.com>
References: <1305680634-10484-1-git-send-email-thutt@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305680634-10484-1-git-send-email-thutt@chromium.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 06:03:54PM -0700, Taylor Hutt wrote:
> Visual inspection shows that max98095_put_eq_enum() and
> max98095_put_bq_enum() each have a possible NULL deref of 'pdata'.
> 
> This change moves the NULL check above the use.

Applied, thanks.  Please try to keep your subject line consistent with
the rest of the subsystem.
