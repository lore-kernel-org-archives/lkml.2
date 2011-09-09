Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab1IIQnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:43:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34458 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759352Ab1IIQnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:43:06 -0400
Date: Fri, 9 Sep 2011 09:43:02 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Geoffrey Wossum <gwossum@acm.org>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: playpaq_wm8510: Return proper error if clk_get
 fails
Message-ID: <20110909164302.GB4070@opensource.wolfsonmicro.com>
References: <1315534538.3275.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315534538.3275.1.camel@phoenix>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 10:15:37AM +0800, Axel Lin wrote:
> Return proper error instead of 0 if clk_get fails.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.
