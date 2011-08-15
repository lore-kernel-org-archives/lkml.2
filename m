Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab1HONzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 09:55:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44723 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753460Ab1HONzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 09:55:00 -0400
Date: Mon, 15 Aug 2011 22:54:51 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Johannes Stezenbach <js@sig21.net>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: sta32x: shortcut the for loop to get ir and mcs
Message-ID: <20110815135438.GA4234@opensource.wolfsonmicro.com>
References: <1313292664.6074.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313292664.6074.1.camel@phoenix>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 11:31:04AM +0800, Axel Lin wrote:
> There is exactly one match or no match at all during the for loop iteration,
> thus we can break from the for loop once a match is found.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.
