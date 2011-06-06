Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab1FFUzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:55:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49122 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753834Ab1FFUzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:55:39 -0400
Date: Mon, 6 Jun 2011 21:55:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ASoC: AD1836: Fix setting the PCM format
Message-ID: <20110606205536.GB27341@opensource.wolfsonmicro.com>
References: <1307360320-4727-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307360320-4727-1-git-send-email-lars@metafoo.de>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 01:38:35PM +0200, Lars-Peter Clausen wrote:
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

All applied, thanks.

> This patch doesn't need to go into stable since there are currently no users of
> PCM formats other than S32, which is the default.

Even if there's no mainline users it's still worth distributing the fix
so out of tree users get to pick it up.
