Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2ABLFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 06:05:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:7722 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab2ABLFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 06:05:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="92114722"
Subject: Re: [PATCH] intel_mid_dma: remove legacy pm interface
From: Vinod Koul <vinod.koul@intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <4EF979DD.7030108@intel.com>
References: <20111215223225.10295.40514.stgit@bob.linux.org.uk>
	 <1324657154.1633.21.camel@vkoul-udesk3>  <4EF979DD.7030108@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jan 2012 16:35:55 +0530
Message-ID: <1325502355.1540.11.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-27 at 09:55 +0200, Adrian Hunter wrote:
> On 23/12/11 18:19, Vinod Koul wrote:
> > On Thu, 2011-12-15 at 22:32 +0000, Alan Cox wrote:
> >> From: Kristen Carlson Accardi <kristen@linux.intel.com>
> >>
> >> Drivers should not support both legacy pm and new framework.
> > Not really.
> > 
> > I am using this driver in our system where we go to D0i3 aka
> > runtime_suspend when DMA is idle.
> > Also we goto D3/S3 aka when traditional suspend is invoked.
> > 
> > So we need both.
> 
> There is no functional change caused by this patch.
> 
> It simply moves suspend/resume calls into dev_pm_ops
> where they really belong now.  It is necessary to prevent
> kernel warnings.
Somehow I didn't read the patch correctly in first place.

Applied now, Thanks

-- 
~Vinod

