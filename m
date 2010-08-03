Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab0HCKel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:34:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:46791 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab0HCKek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:34:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,308,1278313200"; 
   d="scan'208";a="307562848"
Date: Tue, 3 Aug 2010 12:34:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [PATCH] ucb1400_core: avoid calling platform_device_put()
 twice in ucb1400_core_probe error path
Message-ID: <20100803103440.GE2635@sortiz-mobl>
References: <1280824453.19576.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280824453.19576.1.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 04:34:13PM +0800, Axel Lin wrote:
> In the case of goto err2, what we want is to call
> platform_device_del() instead of platform_device_unregister().
> Otherwise, we call platform_device_put() twice.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
