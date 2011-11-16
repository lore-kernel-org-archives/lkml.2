Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab1KPRWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:22:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42395 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528Ab1KPRWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:22:49 -0500
Date: Wed, 16 Nov 2011 17:22:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, drivers@analog.com
Subject: Re: [PATCH 5/7] regmap: Check if a register is writable instead of
 readable in regcache_read
Message-ID: <20111116172246.GS29986@opensource.wolfsonmicro.com>
References: <1321457302-8724-1-git-send-email-lars@metafoo.de>
 <1321457302-8724-5-git-send-email-lars@metafoo.de>
 <20111116161631.GK29986@opensource.wolfsonmicro.com>
 <4EC3E619.70503@metafoo.de>
 <20111116163812.GM29986@opensource.wolfsonmicro.com>
 <4EC3EA61.2000705@metafoo.de>
 <20111116165622.GP29986@opensource.wolfsonmicro.com>
 <4EC3EE32.2090007@metafoo.de>
 <20111116171213.GR29986@opensource.wolfsonmicro.com>
 <4EC3EFB3.9080205@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC3EFB3.9080205@metafoo.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 06:15:31PM +0100, Lars-Peter Clausen wrote:
> On 11/16/2011 06:12 PM, Mark Brown wrote:

> > We should at least check that we actually have a cached value there -
> > the cache is sparse after all.

> That's what the cache already does today, you recently change the rbtree
> implementation to return -ENOENT if there is no cached value.

Oh, sorry -  this is in the cache specific code isn't it?  In that case
yes the check is just totally redundant and can be removed on those
grounds alone.
