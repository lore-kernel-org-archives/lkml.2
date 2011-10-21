Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab1JUI40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 04:56:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41473 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753739Ab1JUI4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 04:56:25 -0400
Date: Fri, 21 Oct 2011 09:56:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Zeng Zhaoming <zhaoming.zeng@freescale.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Set sgtl5000->ldo in ldo_regulator_register
Message-ID: <20111021085622.GC3513@opensource.wolfsonmicro.com>
References: <1319106779.8866.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319106779.8866.1.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 06:32:59PM +0800, Axel Lin wrote:
> Otherwise calling ldo_regulator_remove() does not unregister regulator
> and free memories.

Applied, thanks.
