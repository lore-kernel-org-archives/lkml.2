Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab1I2Jx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:53:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43773 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752690Ab1I2Jx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:53:28 -0400
Date: Thu, 29 Sep 2011 10:53:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: tlv320dac33: Add guarding parentheses to macros
Message-ID: <20110929095326.GD3697@opensource.wolfsonmicro.com>
References: <1317269397.4561.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317269397.4561.1.camel@phoenix>
X-Cookie: You will be misunderstood by everyone.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 12:09:57PM +0800, Axel Lin wrote:
> Put parentheses around macro argument uses. This avoids pitfalls
> for the programmer, where the argument expansion does not give the
> expected result, for example:

Applied, thanks.
