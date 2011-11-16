Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab1KPQYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:24:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35515 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755498Ab1KPQYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:24:45 -0500
Date: Wed, 16 Nov 2011 16:24:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, drivers@analog.com
Subject: Re: [PATCH 2/7] regmap: Make reg_config reg_defaults const
Message-ID: <20111116162442.GL29986@opensource.wolfsonmicro.com>
References: <1321457302-8724-1-git-send-email-lars@metafoo.de>
 <1321457302-8724-2-git-send-email-lars@metafoo.de>
 <20111116161316.GI29986@opensource.wolfsonmicro.com>
 <4EC3E385.4060006@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC3E385.4060006@metafoo.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 05:23:33PM +0100, Lars-Peter Clausen wrote:
> On 11/16/2011 05:13 PM, Mark Brown wrote:

> > You should've got reams of sparse warnings from that - the indexed cache
> > is writing to the defaults table (which is very naughty and i keep
> > thinking about deleting it as a result).

> This patch makes reg_defaults const in the reg_config struct not in the
> regmap struct.

> Since we duplicate the reg_config reg_defaults into the regmap reg_defaults
> the index cache works on a runtime allocated array. (Though I wouldn't
> object to see it gone. For the average uscase it uses more memory and is
> slower than the rbnode cache).

Did you actually check the sparse output?
