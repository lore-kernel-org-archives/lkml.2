Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab2GaGnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:43:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:59273 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207Ab2GaGns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:43:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="179643515"
Subject: Re: [PATCH 0/2] serial: sh-sci: fix compilation breakage (3.6)
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120731060754.GB15380@linux-sh.org>
References: <Pine.LNX.4.64.1207302114440.28003@axis700.grange>
	 <20120731060754.GB15380@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Jul 2012 12:14:42 +0530
Message-ID: <1343717082.1726.14402.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-31 at 15:07 +0900, Paul Mundt wrote:
> On Mon, Jul 30, 2012 at 09:28:18PM +0200, Guennadi Liakhovetski wrote:
> > Hi all
> > 
> > as has been reported in this
> > 
> > http://thread.gmane.org/gmane.linux.kernel/1294256/focus=16001
> > 
> > thread, currently sh-sci doesn't comiple in the mainline and in -next if 
> > CONFIG_SERIAL_SH_SCI_DMA is enabled. This patch series fixes this 
> > breakage.
> > 
> Looks alright to me. Vinod, how do you want to handle this? I can roll
> both of these patches in to my tree with your Acked-by, or I can provide
> you with mine for the sh-sci bits if you want to take it via yours. I'm
> planning on sending my next round of updates to Linus in the next couple
> of days.
Looks fine to me as well

Acked-by: Vinod Koul <vinod.koul@linux.intel.com>


-- 
~Vinod

