Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2BVNUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:20:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:5381 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab2BVNUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:20:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="109429926"
Subject: Re: [PATCH 0/4] dmaengine: i.MX DMA series.
From: Vinod Koul <vinod.koul@intel.com>
To: javier Martin <javier.martin@vista-silicon.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        linux@arm.linux.org.uk, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <CACKLOr1Gn_NR8HPhmyK6DW9W+7CGG8y7yoZm6PE3bH2zt6Ej-g@mail.gmail.com>
References: <1328884300-18801-1-git-send-email-javier.martin@vista-silicon.com>
	 <CACKLOr1Gn_NR8HPhmyK6DW9W+7CGG8y7yoZm6PE3bH2zt6Ej-g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Feb 2012 18:51:32 +0530
Message-ID: <1329916892.24656.110.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 12:51 +0100, javier Martin wrote:
> On 10 February 2012 15:31, Javier Martin
> <javier.martin@vista-silicon.com> wrote:
> > Patches 1-3 have already been sent to the list (not merged yet)
> > but they are submitted so that everyone can get the whole picture
> > of what we're trying to do here.
> >
> > A new patch(4) has been added which adds support for multiple
> > descriptors.
> >
> > [PATCH 1/4] dmaengine: Add support for MEMCPY for imx-dma.
> > [PATCH 2/4] i.MX DMA: Add support for 2D transfers.
> > [PATCH 3/4] dmaengine: i.MX: Add support for interleaved transfers.
> > [PATCH 4/4] dmaengine: Add support for multiple descriptors for imx-dma.
> 
> Hi,
> what do you think of this series?
> 
> Vinod: your concern about patch 1 is solved in patch 4
> Sascha: I know you are not comfortable with patch 2 since it adds code
> to a file which is meant to be removed. However, is there a chance you
> accept it without me having to rewrite the whole series?
Without 2, I think this patch set looks okay. Sascha have you tested
this series, if so please let me know, I can apply the rest.


-- 
~Vinod

