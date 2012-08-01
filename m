Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2HAT4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:56:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32907 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155Ab2HAT4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:56:42 -0400
Date: Wed, 1 Aug 2012 20:56:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: s2mps11: Use array to save pointer to rdev
Message-ID: <20120801195640.GE4483@opensource.wolfsonmicro.com>
References: <1342145560.19496.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342145560.19496.5.camel@phoenix>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 10:12:40AM +0800, Axel Lin wrote:
> The number of regulator is known at compile time, use array to save pointer to
> rdev makes the code simpler.

Applied, thanks.
