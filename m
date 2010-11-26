Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab0KZMP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 07:15:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:54998 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab0KZMPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 07:15:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,260,1288594800"; 
   d="scan'208";a="630519055"
Date: Fri, 26 Nov 2010 13:15:47 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 1/2] rdc321x-gpio: fix null pointer dereference while
 accessing platform_data
Message-ID: <20101126121546.GM5520@sortiz-mobl>
References: <201011261039.54817.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011261039.54817.florian@openwrt.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On Fri, Nov 26, 2010 at 10:39:54AM +0100, Florian Fainelli wrote:
> rdc321x-gpio currently fetches its driver specific data by using the platform_
> device->platform_data pointer, this is wrong because the mfd device which
> registers our platform_device has been added using mfd_add_device() which sets
> the platform_device->driver_data pointer instead.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> CC: stable@kernel.org
I'll take those 2 patches.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
