Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3AHQM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:12:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:31095 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383Ab3AHQM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:12:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,432,1355126400"; 
   d="scan'208";a="188895842"
Date: Tue, 8 Jan 2013 07:48:13 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-kernel@vger.kernel.org, djbw@fb.com
Subject: Re: [PATCH] dmaengine: imx-dma: Disable use of hw_chain to fix
 sg_dma transfers.
Message-ID: <20130108154813.GI19691@intel.com>
References: <1351612730-19029-1-git-send-email-javier.martin@vista-silicon.com>
 <CACKLOr1NXVM3kUFkSMVf=BK9g4EzwXbj2-gvxKjfThe4kAcTsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKLOr1NXVM3kUFkSMVf=BK9g4EzwXbj2-gvxKjfThe4kAcTsg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 04:37:44PM +0100, javier Martin wrote:
> On 30 October 2012 16:58, Javier Martin <javier.martin@vista-silicon.com> wrote:
> > HW chaining is currently broken in imx-dma. It can be easily reproduced doing
> > intensive accesses to a external MMC card and checking how the file system
> > is corrupted.
> >
> > Preventing the driver to use HW chaining solves these issues.
> >
> >
Applied now.

Sorry for this miss & thanks for reminding

--
~Vinod
