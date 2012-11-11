Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab2KKXdH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 18:33:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:43702 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab2KKXdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 18:33:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,759,1344236400"; 
   d="scan'208";a="245347542"
Date: Mon, 12 Nov 2012 00:33:02 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 0/8] mfd: Batch together MFD related patches
Message-ID: <20121111233302.GE27828@sortiz-mobl>
References: <1352128236-11554-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352128236-11554-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, Nov 05, 2012 at 04:10:28PM +0100, Lee Jones wrote:
> Hi Sam,
> 
> I know you've been busy giving NFC presentations at ELC, but ... :)
> 
> All these patches have been on the list in various other patch-sets
> for some time and have been reviewed by some key people already. All
> other patches from the patch-sets have been taken, so I thought I'd
> batch these up for easy review/acceptance.
Thanks, much appreciated.
I applied all of them to my for-next branch. I don't think patch #1 is rc
material though, as it only fixes a boot warning and not an actual bug or
regression.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
