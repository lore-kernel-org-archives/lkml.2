Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab1KPRhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:37:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44197 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757582Ab1KPRhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:37:33 -0500
Date: Wed, 16 Nov 2011 17:37:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, drivers@analog.com
Subject: Re: [PATCH 6/7] regmap: Add support for 10/14 register formating
Message-ID: <20111116173729.GD31558@opensource.wolfsonmicro.com>
References: <1321457302-8724-1-git-send-email-lars@metafoo.de>
 <1321457302-8724-6-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321457302-8724-6-git-send-email-lars@metafoo.de>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 04:28:21PM +0100, Lars-Peter Clausen wrote:

> +
> +	out[2] = val;
> +	out[1] = (val >> 8) | (reg << 6);
> +	out[0] = reg >> 2;
> +}

Applied but it took me a couple of goes to veryify that this was correct
as you're filling things in the opposite order to that which things are
transmitted in.
