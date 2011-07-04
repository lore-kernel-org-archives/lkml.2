Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab1GDRZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:25:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:30947 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907Ab1GDRZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:25:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,474,1304319600"; 
   d="scan'208";a="21428885"
Date: Mon, 4 Jul 2011 19:25:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        parthab@india.ti.com, tony@atomide.com, khilman@ti.com,
        b-cousson@ti.com, paul@pwsan.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 0/6 V2] arm: omap: usb: Runtime PM support for EHCI and
 OHCI drivers
Message-ID: <20110704172538.GQ3021@sortiz-mobl>
References: <1309546474-15363-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309546474-15363-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keshava,

On Sat, Jul 02, 2011 at 12:24:28AM +0530, Keshava Munegowda wrote:
> From: Keshava Munegowda <Keshava_mgowda@ti.com>
> 
> The Hwmod structures and Runtime PM features are implemented
> For EHCI and OHCI drivers of OMAP3 and OMAP4.
> The global suspend/resume of EHCI and OHCI
> is validated on OMAP3430 sdp board with these patches.
Hust fr your information, this will not make it to 3.0. I have a revert of
your patch queued for the 3.0 MFC update pull request that I'm going to send
soon.
So this is 3.1 merge window material.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
