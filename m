Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab1KXP3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:29:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57295 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927Ab1KXP3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:29:32 -0500
Date: Thu, 24 Nov 2011 15:29:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 05/11] mfd: Remove redundant spi driver bus initialization
Message-ID: <20111124152930.GO8470@opensource.wolfsonmicro.com>
References: <1322148561-25138-1-git-send-email-lars@metafoo.de>
 <1322148561-25138-5-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322148561-25138-5-git-send-email-lars@metafoo.de>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 04:29:15PM +0100, Lars-Peter Clausen wrote:
> In ancient times it was necessary to manually initialize the bus field of an
> spi_driver to spi_bus_type. These days this is done in spi_driver_register(),
> so we can drop the manual assignment.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
