Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248Ab0HEMLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:11:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39425 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755476Ab0HEMLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:11:48 -0400
Date: Thu, 5 Aug 2010 13:11:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/2] lp3971: remove unnecessary ret value checking in
 lp3971_i2c_write()
Message-ID: <20100805121145.GD13146@rakim.wolfsonmicro.main>
References: <1280979638.1238.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280979638.1238.2.camel@mola>
X-Cookie: Type louder, please.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 11:40:38AM +0800, Axel Lin wrote:
> i2c_smbus_write_byte_data() returns zero or negative value,
> therefore no need to check if ret is greater than zero or not.

> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but can I once more renew my request that you make some effort to
provide subject lines for your patches which are consistent with the
standard used for the area of the kernel you're submitting to?
