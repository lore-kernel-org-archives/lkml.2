Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab2GEPMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:12:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:60406 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab2GEPML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:12:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="188772082"
Date: Thu, 5 Jul 2012 17:23:34 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mfd: tps65910: add support for enabling external
 32-kHz oscillator
Message-ID: <20120705152334.GH18200@sortiz-mobl>
References: <1340878822-28444-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340878822-28444-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,

On Thu, Jun 28, 2012 at 12:20:20PM +0200, Johan Hovold wrote:
> These patches (against v3.5-rc4) add support for enabling the external 32-kHz
> oscillator input in tps6591x devices. Depending on boot-mode, the internal
> RC-oscillator may be used by default and the external crystal-oscillator input
> must be enabled by clearing a flag in the device-control register.
> 
> These patches are needed in order to get an accurate system clock on boards
> such as the Craneboard.
> 
> Thanks,
> Johan
> 
> Johan Hovold (2):
>   mfd: tps65910: add support for enabling external 32-kHz oscillator
>   mfd: tps65910: add device-tree entry to enable external 32-kHz
>     oscillator
Both patches applied, although the misc_init() naming is quite vague. If you
can come up with a follow up patch for a better name, I'll take it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
