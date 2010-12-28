Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab0L1Xm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 18:42:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40391 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752716Ab0L1Xm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 18:42:26 -0500
Date: Tue, 28 Dec 2010 23:42:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9 v2] ASoC: codecs: Fix register cache incoherencies
Message-ID: <20101228234237.GC3591@opensource.wolfsonmicro.com>
References: <1293568684-9626-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293568684-9626-1-git-send-email-lars@metafoo.de>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 09:37:54PM +0100, Lars-Peter Clausen wrote:
> The multi-component patch(commit f0fba2ad1) moved the allocation of the
> register cache from the driver to the ASoC core. Most drivers where adjusted to
> this, but there are also some drivers now which use a mixture of their own

Applied 2-9 for 2.6.37; patch 1 isn't really needed as a bug fix as we
just waste a bit of memory rather than crashing if something goes wrong.
I've applied that one for 2.6.38.
