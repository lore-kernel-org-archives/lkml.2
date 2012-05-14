Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab2ENULf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:11:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:29763 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218Ab2ENULe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:11:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99993858"
Date: Mon, 14 May 2012 22:21:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] mfd: wm8400: Don't support non-modular build
Message-ID: <20120514202119.GB12740@sortiz-mobl>
References: <1336986796-31491-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336986796-31491-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, May 14, 2012 at 10:13:15AM +0100, Mark Brown wrote:
> It's relying on non-exported symbols.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Both patches applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
