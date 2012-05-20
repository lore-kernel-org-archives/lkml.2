Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2ETNMR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 09:12:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:11594 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab2ETNMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 09:12:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="168758790"
Date: Sun, 20 May 2012 15:22:13 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm831x: Emulate active low IRQs as well as active
 high IRQs
Message-ID: <20120520132213.GX12015@sortiz-mobl>
References: <1337356922-21650-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337356922-21650-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, May 18, 2012 at 05:02:02PM +0100, Mark Brown wrote:
> As with the existing emulation this should not be used in production
> systems but is useful for test purposes.
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
