Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab1FTKRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:17:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:55973 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633Ab1FTKRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:17:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,392,1304319600"; 
   d="scan'208";a="15489415"
Date: Mon, 20 Jun 2011 12:16:43 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Fix error handling if BUG() isn't enabled in WM8994
Message-ID: <20110620101643.GD22420@sortiz-mobl>
References: <1308309581-8400-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308309581-8400-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Jun 17, 2011 at 12:19:41PM +0100, Mark Brown wrote:
> Even if we would've BUG()ed we should still tidy up after ourselves if that
> isn't enabled in the kernel config.
I applied this one as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
