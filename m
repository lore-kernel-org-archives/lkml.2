Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0K2KsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:48:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:44640 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab0K2KsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:48:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,275,1288594800"; 
   d="scan'208";a="354361021"
Date: Mon, 29 Nov 2010 11:48:13 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-geode@lists.infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, dsd@laptop.org, cjb@laptop.org
Subject: Re: [PATCH 2/4] cs5535-gpio: convert from pci device to platform
 device
Message-ID: <20101129104812.GA2332@sortiz-mobl>
References: <20101023004109.319bbdef@queued.net>
 <20101126204426.162ebc75@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126204426.162ebc75@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Fri, Nov 26, 2010 at 08:44:26PM -0800, Andres Salomon wrote:
> Samuel, thanks for applying the mfd patch.  I'm not sure how the rest
> of these should be handled; they depend upon the first patch.  Would you
> prefer they go through the mfd tree, or go in via Andrew's tree?
I typically take them, unless the corresponding subsystem maintainers disagree
with it. I also really much prefer to get an ACK from them before taking the
patches.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
