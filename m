Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1HLCkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 22:40:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33152 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752322Ab1HLCkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 22:40:16 -0400
Date: Fri, 12 Aug 2011 11:40:08 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: sgtl5000: fix module device table type for
 sgtl5000_dt_ids
Message-ID: <20110812024006.GA10218@opensource.wolfsonmicro.com>
References: <1313072356.9215.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313072356.9215.0.camel@phoenix>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 10:19:16PM +0800, Axel Lin wrote:
> The module device table for of_device_id should use "of" type.

Applied, thanks.
