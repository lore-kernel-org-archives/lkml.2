Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab1E1R6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 13:58:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52259 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755225Ab1E1R6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 13:58:18 -0400
Date: Sun, 29 May 2011 01:58:12 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Hsiang <peter.hsiang@maxim-ic.com>,
        Peter Hsiang <cdefgab1288@gmail.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Remove redundant freq assignment for
 max98095->sysclk/max98088->sysclk
Message-ID: <20110528175811.GB31225@opensource.wolfsonmicro.com>
References: <1306510253.19556.36.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306510253.19556.36.camel@phoenix>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 11:30:53PM +0800, Axel Lin wrote:
> Current implementation set max98095->sysclk/max98088->sysclk to freq twice.
> Set it once is enough, this patch removes the first assignment in case
> we may set invalid clock frequency to max98095->sysclk/max98088->sysclk.

Applied, thanks.
