Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab2GRDPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 23:15:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:6952 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab2GRDO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 23:14:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="169659412"
Subject: Re: [PATCH 5/7 v2] dma: sh: use an integer slave ID to improve API
 compatibility
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1207161445470.18978@axis700.grange>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
	 <1341484183-10757-6-git-send-email-g.liakhovetski@gmx.de>
	 <1342418828.1726.37.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1207160832540.12302@axis700.grange>
	 <1342421587.1726.49.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1207160907180.12302@axis700.grange>
	 <1342427305.1726.50.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1207161040070.12302@axis700.grange>
	 <1342431452.1726.54.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1207161155280.12302@axis700.grange>
	 <1342434256.1726.57.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1207161249260.18978@axis700.grange>
	 <1342437179.1726.61.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1207161445470.18978@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Jul 2012 08:44:53 +0530
Message-ID: <1342581293.1726.66.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 14:47 +0200, Guennadi Liakhovetski wrote:
> > > Yes, that's right - these values have to be written to DMAC channel 
> > > configuration registers, so, we do not have to change anything, those 
> > > values can remain DMAC parameters and be passed to it directly from 
> > > platform data.
> > Can you get that in future fixes.
> 
> Sorry, what exactly would you like to have fixed here? Above I just 
> described how the driver already functions, what changes do you see 
> necessary? 
Why should client pass these two values. So the parameters which can be
calculated should be, and rest should dmacs platform data and not
clients.
And after the removal of the slave and adddr fields, you find that you
no longer need your specific slave structure and that can be elimnated
completely.

-- 
~Vinod

