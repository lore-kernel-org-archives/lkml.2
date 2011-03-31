Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab1CaGQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:16:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:57017 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab1CaGQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:16:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,274,1299484800"; 
   d="scan'208";a="673596276"
Subject: Re: [PATCH] dma: ipu: Convert interupt code
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <alpine.LFD.2.00.1103251220000.31464@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103251220000.31464@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Mar 2011 11:16:22 +0530
Message-ID: <1301550382.18522.9.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 12:21 +0100, Thomas Gleixner wrote:
> Convert to the new irq chip functions and cleanup the name space.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  drivers/dma/ipu/ipu_irq.c |   58 +++++++++++++++++++++++-----------------------
>  1 file changed, 29 insertions(+), 29 deletions(-)
This looks fine, I will apply it once I merged .39-rc1 to my tree

-- 
~Vinod

