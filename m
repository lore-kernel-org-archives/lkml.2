Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1AaKug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:50:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:48061 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab1AaKuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:50:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,403,1291622400"; 
   d="scan'208";a="598012821"
Date: Mon, 31 Jan 2011 11:50:31 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Heiko Schocher <hs@denx.de>
Cc: linuxppc-dev@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@ozlabs.org, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/4 v4] video, sm501: add I/O functions for use on
 powerpc
Message-ID: <20110131105030.GD5954@sortiz-mobl>
References: <1291451028-22532-1-git-send-email-hs@denx.de>
 <1295863040-11086-1-git-send-email-hs@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295863040-11086-1-git-send-email-hs@denx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Mon, Jan 24, 2011 at 10:57:20AM +0100, Heiko Schocher wrote:
> - add read/write functions for using this driver
>   also on powerpc plattforms
Not sure whose tree this is going through. Probably Paul's one though.
The mfd part looks fine to me, please add my:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
