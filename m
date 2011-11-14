Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab1KNVp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 16:45:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44496 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755558Ab1KNVpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 16:45:55 -0500
Date: Mon, 14 Nov 2011 21:45:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] regmap: Fix memory leak in regcache_init error path
Message-ID: <20111114214552.GM6528@opensource.wolfsonmicro.com>
References: <1321263619-25891-1-git-send-email-lars@metafoo.de>
 <1321263619-25891-3-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321263619-25891-3-git-send-email-lars@metafoo.de>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 10:40:17AM +0100, Lars-Peter Clausen wrote:
> Make sure all allocated memory gets freed again in case initializing the cache
> failed.

Applied, thanks.
