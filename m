Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0L1Xnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 18:43:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40401 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752862Ab0L1Xnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 18:43:31 -0500
Date: Tue, 28 Dec 2010 23:43:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] ASoC: codecs: wm8753: Fix register cache
 incoherency
Message-ID: <20101228234342.GD3591@opensource.wolfsonmicro.com>
References: <1293568684-9626-1-git-send-email-lars@metafoo.de>
 <1293568684-9626-10-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293568684-9626-10-git-send-email-lars@metafoo.de>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 09:38:03PM +0100, Lars-Peter Clausen wrote:

> Furthermore the generic cache uses zero-based numbering while the wm8753 cache
> uses one-based numbering.

This is why the driver never got updated to use the generic code, FWIW -
the cleverness made it more effort to convert.
