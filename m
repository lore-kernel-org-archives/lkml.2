Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1HUXLM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 19:11:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:50508 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598Ab1HUXLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 19:11:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="40646538"
Date: Mon, 22 Aug 2011 01:13:09 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        stable@kernel.org
Subject: Re: [PATCH] mfd: Fix value of WM8994_CONFIGURE_GPIO
Message-ID: <20110821231309.GC4607@sortiz-mobl>
References: <1312362269-3363-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312362269-3363-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Aug 03, 2011 at 06:04:29PM +0900, Mark Brown wrote:
> This needs to be an out of band value for the register and on this device
> registers are 16 bit so we must shift left one to the 17th bit.
Patch applied to for-next and queued into for-linus as well.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
