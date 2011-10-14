Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab1JNHZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 03:25:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:43802 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500Ab1JNHZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 03:25:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,344,1315206000"; 
   d="scan'208";a="78024165"
Subject: Re: [PATCH 09/10] USB: move to dma_transfer_direction
From: Vinod Koul <vinod.koul@linux.intel.com>
To: balbi@ti.com
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20111014072058.GE20436@legolas.emea.dhcp.ti.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
	 <1318570705-17595-10-git-send-email-vinod.koul@intel.com>
	 <20111014072058.GE20436@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 12:47:05 +0530
Message-ID: <1318576625.1546.385.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 10:20 +0300, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Oct 14, 2011 at 11:08:24AM +0530, Vinod Koul wrote:
> > From: Vinod Koul <vinod.koul@linux.intel.com>
> 
> please add a description here.
> 
> > Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> >  drivers/usb/musb/ux500_dma.c     |    4 ++--
> >  drivers/usb/renesas_usbhs/fifo.c |    4 ++--
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> can you split this patch into two parts ? One for musb and one renesas ?
Well it was easier to do small change per subsystem rather than per driver

Can split if you insist

-- 
~Vinod

