Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab1LLRdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:33:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:43515 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab1LLRdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:33:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="86345812"
Date: Mon, 12 Dec 2011 18:38:19 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: NeilBrown <neilb@suse.de>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 0/4] fixes for twl4030-irq in mainline
Message-ID: <20111212173819.GT13952@sortiz-mobl>
References: <20111126201334.16080.85045.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111126201334.16080.85045.stgit@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On Sun, Nov 27, 2011 at 07:17:41AM +1100, NeilBrown wrote:
> Hi,
>   The recent tidying up of twl4030-irq seems to have left it broken.
> At least it doesn't work for me on my gta04 (www.gta04.org).  The
> first interrupt from the device freezes the whole system (by being
> constantly delivered)
> 
> The following 4 patches make it work for me and addresses some other
> less critical issues like a typo in a comment :-)

Thanks, I applied all 4 of them.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
