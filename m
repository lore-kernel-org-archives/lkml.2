Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935519Ab1IOXur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:50:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42573 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935498Ab1IOXuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:50:46 -0400
Date: Fri, 16 Sep 2011 00:50:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Cliff Cai <Cliff.Cai@analog.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: bf5xx-ad73311: Fix prototype for bf5xx_probe
Message-ID: <20110915235044.GH3218@opensource.wolfsonmicro.com>
References: <1316055896.3496.8.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316055896.3496.8.camel@phoenix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 11:04:56AM +0800, Axel Lin wrote:
> Fix below build warning:
> sound/soc/blackfin/bf5xx-ad73311.c: warning: initialization from incompatible pointer type

Applied, thanks.
