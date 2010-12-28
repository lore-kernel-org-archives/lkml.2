Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab0L1Xdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 18:33:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33687 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752053Ab0L1Xdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 18:33:53 -0500
Date: Tue, 28 Dec 2010 23:34:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: codecs: Add missing control_type initialization
Message-ID: <20101228233404.GA3591@opensource.wolfsonmicro.com>
References: <1293566937-7937-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293566937-7937-1-git-send-email-lars@metafoo.de>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 09:08:57PM +0100, Lars-Peter Clausen wrote:
> Some codec drivers do not initialize the control_type field in their private
> device struct, but still use it when calling snd_soc_codec_set_cache_io.
> This patch fixes the issue by properly initializing it in the drivers probe
> functions.

Applied for 2.6.37.  Some of the drivers could skip this as the hardware
only supports one bus but it doesn't really matter for the fix.
