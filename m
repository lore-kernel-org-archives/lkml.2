Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab1KQQvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:51:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37153 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756901Ab1KQQvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:51:39 -0500
Date: Thu, 17 Nov 2011 16:51:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH  v2 1/2] regmap: Properly round cache_word_size
Message-ID: <20111117165137.GA9008@opensource.wolfsonmicro.com>
References: <1321472044-15686-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321472044-15686-1-git-send-email-lars@metafoo.de>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 08:34:03PM +0100, Lars-Peter Clausen wrote:
> regcache currently only properly works with val bit sizes of 8 or 16, since
> it will, when calculating the cache word size, round down. This causes the
> cache storage to be too small to hold the full register value. Fix this by
> rounding up instead.

Applied, thanks.
