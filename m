Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab1I1E3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 00:29:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:28524 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab1I1E3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 00:29:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,453,1312182000"; 
   d="scan'208";a="68142067"
Subject: Re: [PATCH] dma: shdma: transfer based runtime PM
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <Pine.LNX.4.64.1109251612320.11831@axis700.grange>
References: <Pine.LNX.4.64.1108181650530.5245@axis700.grange>
	 <1314282386.1606.42.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108251636190.17190@axis700.grange>
	 <1314283286.1606.52.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108251648100.17190@axis700.grange>
	 <1314292850.1606.88.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108260107550.17190@axis700.grange>
	 <1314619909.1606.130.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108291419410.31184@axis700.grange>
	 <1314622113.1606.134.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108300906590.19151@axis700.grange>
	 <1314698257.1606.159.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108301321500.19151@axis700.grange>
	 <Pine.LNX.4.64.1109051007230.1112@axis700.grange>
	 <1315227964.26251.68.camel@vkoul-udesk3>
	 <1315235596.26251.201.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1109251612320.11831@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 09:53:25 +0530
Message-ID: <1317183805.1573.1642.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-25 at 16:19 +0200, Guennadi Liakhovetski wrote:
> Hi Vinod
> 
> On Mon, 5 Sep 2011, Vinod Koul wrote:
> 
> [snip]
> 
> > This patch fails to apply for me, can you please rebase it to me tree
> > and resend, I will apply it later this week
> 
> Sorry, it didn't apply, because I apparently forgot to send out this 
> patch:
> 
> http://marc.info/?l=linux-kernel&m=131695995404173&w=2
> 
> which I've also cc'ed to you a couple of minutes ago. With that patch 
> applied first, the patch in question
> 
> http://marc.info/?l=linux-kernel&m=131386369726846&w=2
> 
> still applies cleanly on top of the "next" branch of your slave-dma tree.
I have applied both, Thanks


-- 
~Vinod

