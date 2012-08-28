Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab2H1TDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 15:03:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:37263 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab2H1TDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 15:03:04 -0400
Message-ID: <1346181008.27195.4.camel@vkoul-mobl4>
Subject: Re: [PATCH] dma: tegra: remove useless include of <mach/*.h>
From: Vinod Koul <vkoul@infradead.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: vinod.koul@intel.com, Stephen Warren <swarren@wwwdotorg.org>,
        Dan Williams <djbw@fb.com>, linux-kernel@vger.kernel.org
Date: Wed, 29 Aug 2012 00:40:08 +0530
In-Reply-To: <503CFE25.2070109@nvidia.com>
References: <1346137305-7226-1-git-send-email-swarren@wwwdotorg.org>
	 <503CFE25.2070109@nvidia.com>
Organization: 
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-28 at 10:21 -0700, Stephen Warren wrote:
> On 08/28/2012 12:01 AM, Stephen Warren wrote:
> > From: Stephen Warren <swarren@nvidia.com>
> > 
> > Nothing from this file is needed, so remove the include. This helps
> > single zImage work by reducing use of the mach-tegra/include/mach/
> > directory.
> 
> BTW, it'd be easiest for me to take this through the Tegra tree, so it
> can be consolidated with other header re-org changes.
Sure, so here is the ack

Acked-by: Vinod Koul <vinod.koul@linux.intel.com>

-- 
~Vinod Koul
Intel Corp.

