Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0LGP0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:26:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32890 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754058Ab0LGP0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:26:52 -0500
Date: Tue, 7 Dec 2010 15:26:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Fix resource leak if soc_register_ac97_dai_link
 failed
Message-ID: <20101207152650.GE9689@rakim.wolfsonmicro.main>
References: <1291726590.2760.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291726590.2760.3.camel@phoenix>
X-Cookie: E Pluribus Unix
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 08:56:30PM +0800, Axel Lin wrote:
> Properly free the resources in the case of soc_register_ac97_dai_link failure.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.
