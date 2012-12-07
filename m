Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424351Ab2LGDsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 22:48:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46426 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1424226Ab2LGDsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 22:48:12 -0500
Date: Fri, 7 Dec 2012 12:48:06 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH] spi: Fix comparison of different integer types
Message-ID: <20121207034804.GC26070@opensource.wolfsonmicro.com>
References: <1354836947-31078-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354836947-31078-1-git-send-email-grant.likely@secretlab.ca>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 11:35:47PM +0000, Grant Likely wrote:
> Fix problem discovered with sparse:
> + drivers/spi/spi.c:1554:37: sparse: incompatible types in comparison expression (different signedness)
> drivers/spi/spi.c: In function 'spi_write_then_read':
> drivers/spi/spi.c:1554:23: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> 
> The change to SPI_BUFSIZ was introduced in commit b3a223ee2, "spi:
> Remove SPI_BUFSIZ restriction on spi_write_then_read()"

Thanks.
