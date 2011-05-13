Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab1EMSMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:12:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:18043 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab1EMSMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:12:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,365,1301900400"; 
   d="scan'208";a="435760388"
Date: Fri, 13 May 2011 20:12:34 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: linux-kernel@vger.kernel.org, philipp.zabel@gmail.com
Subject: Re: [PATCH v3] mfd: Add ASIC3 LED support
Message-ID: <20110513181209.GW8970@sortiz-mobl>
References: <E1QJXcM-0007Ed-Mz@outmx08.plus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QJXcM-0007Ed-Mz@outmx08.plus.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Mon, May 09, 2011 at 09:03:49PM +0000, Paul Parsons wrote:
> Add LED support for the HTC ASIC3. Underlying support is provided by the mfd/asic3 and leds/leds-asic3 drivers. An example configuration is provided by the pxa/hx4700 platform.
>
Good. I had a pending email requesting that you push the asic3_led pointer as
a platform_data pointer. By the way, it's quite handy when people expose the
changes they added between Vn and Vn+1.
 
The code looks fine now, but I'd prefer to get 2 separate patches for that:
1 for the LED driver and the asic3.h changes and a second one for the asic3.c
changes. I'll merge both at the same time.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
