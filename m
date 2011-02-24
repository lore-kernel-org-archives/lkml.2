Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1BXJjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 04:39:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36857 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751987Ab1BXJjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 04:39:41 -0500
Date: Thu, 24 Feb 2011 09:39:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@slimlogic.co.uk>, Yong Shen <yong.shen@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] regulator, mc13xxx: Remove pointless test for unsigned
 less than zero
Message-ID: <20110224093939.GH8226@opensource.wolfsonmicro.com>
References: <alpine.LNX.2.00.1102232341030.28678@swampdragon.chaosbits.net>
 <1298538787.2454.24.camel@realization>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298538787.2454.24.camel@realization>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 10:13:07AM +0100, Alberto Panizzo wrote:

> Ok for me, but the next time give also the revision of the kernel
> your patch is based on (Linus one, Liam one ..) that is the 
> linus-2.6.38-rc6

There is no need to do this for normal kernel submissions, it should be
obvious where the patch is going (either Linus' tree for urgent enough
fixes or whatever's in -next for the most part).
