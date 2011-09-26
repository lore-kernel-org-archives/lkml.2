Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab1IZI66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 04:58:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42108 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750851Ab1IZI6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 04:58:55 -0400
Date: Mon, 26 Sep 2011 09:58:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Roy Huang <roy.huang@analog.com>,
        Cliff Cai <cliff.cai@analog.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Drop exporting ad1980_dai
Message-ID: <20110926085853.GC2946@opensource.wolfsonmicro.com>
References: <1316861023.11157.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316861023.11157.4.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 24, 2011 at 06:43:43PM +0800, Axel Lin wrote:
> ad1980_dai is not used outside this driver,
> thus drop exporting it.

Applied, thanks.
