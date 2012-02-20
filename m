Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab2BTPIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 10:08:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:21710 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab2BTPIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 10:08:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108649559"
Date: Mon, 20 Feb 2012 16:15:43 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: jhbird.choi@samsung.com, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] mfd: variable dereferenced before check
Message-ID: <20120220151543.GV5387@sortiz-mobl>
References: <1326418852-19378-1-git-send-email-jhbird.choi@samsung.com>
 <20120115111553.GA3040@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120115111553.GA3040@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, Jan 15, 2012 at 03:15:55AM -0800, Mark Brown wrote:
> On Fri, Jan 13, 2012 at 10:40:52AM +0900, jhbird.choi@samsung.com wrote:
> > From: Jonghwan Choi <jhbird.choi@samsung.com>
> > 
> > Remove "wm8350->irq_base = pdata->irq_base" to avoid
> > null pointer exception and wm8350->irq_base got from
> > irq_alloc_descs().
> 
> Always send patches to the relevant maintainers - for the MFD subsystem
> the maintainer is Samuel Ortiz.
Thanks for the notification. Patch applied now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
