Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab0IJPwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:52:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:26097 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab0IJPwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:52:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,347,1280732400"; 
   d="scan'208";a="605759580"
Date: Fri, 10 Sep 2010 17:53:00 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Rapoport <mike@compulab.co.il>, eric miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH 1/3] mfd: da903x - fix da903x_add_subdevs error path
Message-ID: <20100910155259.GL2561@sortiz-mobl>
References: <1282628645.6074.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282628645.6074.1.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Aug 24, 2010 at 01:44:05PM +0800, Axel Lin wrote:
> This patch fixes da903x_add_subdevs error path:
> 1. return -ENOMEM if platform_device_alloc() fail.
> 2. call platform_device_put() if platform_device_add() fail.
All 3 patches applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
