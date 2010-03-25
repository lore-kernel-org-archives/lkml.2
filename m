Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0CYL0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 07:26:42 -0400
Received: from mga05.intel.com ([192.55.52.89]:49464 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754518Ab0CYL0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 07:26:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,306,1267430400"; 
   d="scan'208";a="783810779"
Date: Thu, 25 Mar 2010 12:27:28 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, wim@iguana.be
Subject: Re: [PATCH 0/4 v3] RDC321x southbridge and GPIO support
Message-ID: <20100325112727.GC3720@sortiz.org>
References: <201003210106.01673.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003210106.01673.florian@openwrt.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On Sun, Mar 21, 2010 at 01:06:01AM +0100, Florian Fainelli wrote:
> Hi Samuel, Andrew,
> 
> This is the third round of the RDC321x southbridge and GPIO support, this 
> version should hopefully address all of your comments.
All 4 (I took v2 for the watchdog) patches applies, thanks.

Cheers,
Samuel.


> Thanks!
> 
> Florian Fainelli (4):
>   MFD: add support for the RDC321x southbridge
>   GPIO: add support for RDC321x GPIO controller
>   WATCHDOG: convert rdc321x_wdt to use southbridge pci device
>   x86: remove rdc321x_defs.h

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
