Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab1IERpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 13:45:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57953 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751223Ab1IERpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 13:45:09 -0400
Date: Mon, 5 Sep 2011 10:45:04 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: [PATCH 2/3] ASoC: Allow codecs to provide their own regmap
 configuration
Message-ID: <20110905174503.GI3889@opensource.wolfsonmicro.com>
References: <1315228682-1097-1-git-send-email-lars@metafoo.de>
 <1315228682-1097-2-git-send-email-lars@metafoo.de>
 <20110905172916.GG3889@opensource.wolfsonmicro.com>
 <4E650A3A.5050807@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E650A3A.5050807@metafoo.de>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 07:43:22PM +0200, Lars-Peter Clausen wrote:

> I think it is useful, since we avoid duplicating that ugly switch statement
> and we also have to wrap regmap_write and regmap_read, duplicating that in each
> codec driver doesn't make sense.

When the CODEC drivers do the probe they should be setting the regmap up
in their individual bus probe functions so no switch statement.
