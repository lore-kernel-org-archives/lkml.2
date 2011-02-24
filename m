Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab1BXJhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 04:37:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36851 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751987Ab1BXJhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 04:37:20 -0500
Date: Thu, 24 Feb 2011 09:37:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Yong Shen <yong.shen@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>
Subject: Re: [PATCH] regulator, mc13xxx: Remove pointless test for unsigned
 less than zero
Message-ID: <20110224093717.GG8226@opensource.wolfsonmicro.com>
References: <alpine.LNX.2.00.1102232341030.28678@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1102232341030.28678@swampdragon.chaosbits.net>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 11:45:55PM +0100, Jesper Juhl wrote:
> The variable 'val' is a 'unsigned int', so it can never be less than zero. 
> This fact makes the "val < 0" part of the test done in BUG_ON() in 
> mc13xxx_regulator_get_voltage() rather pointles since it can never have 
> any effect.
> This patch removes the pointless test.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
