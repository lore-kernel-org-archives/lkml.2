Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494Ab2IKJij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 05:38:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:4910 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758329Ab2IKJib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 05:38:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,402,1344236400"; 
   d="scan'208";a="143719732"
Date: Tue, 11 Sep 2012 11:38:26 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <rmk@arm.linux.org.uk>,
        "v3.4+" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/7] mfd: max8925: Move _IO resources out of
 ioport_ioresource
Message-ID: <20120911093826.GJ3647@sortiz-mobl>
References: <1344364969-32489-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344364969-32489-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Aug 07, 2012 at 07:42:43PM +0100, Mark Brown wrote:
> The removal of mach/io.h from most ARM platforms also set the range of
> valid IO ports to be empty for most platforms when previously any 32
> bit integer had been valid. This makes it impossible to add IO resources
> as the added range is smaller than that of the root resource for IO ports.
> 
> Since we're not really using IO memory at all fix this by defining our
> own root resource outside the normal tree and make that the parent of
> all IO resources. This also ensures we won't conflict with read IO ports
> if we ever run on a platform which happens to use them.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: stable@vger.kernel.org (v3.4+)
> ---
>  drivers/mfd/max8925-core.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
Thanks a lot for the follow up. The 7 patches are applied to my for-next
branch now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
