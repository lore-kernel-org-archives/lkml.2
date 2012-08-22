Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2HVGiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:38:50 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:29500 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894Ab2HVGis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:38:48 -0400
X-IronPort-AV: E=Sophos;i="4.77,808,1336341600"; 
   d="scan'208";a="170476844"
Date: Wed, 22 Aug 2012 08:38:45 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: Barry Song <21cnbao@gmail.com>, Julia Lawall <julia.lawall@lip6.fr>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Barry Song <baohua.song@csr.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] drivers/dma/sirf-dma.c: fix usage of devm functions
In-Reply-To: <1345617275.1895.83.camel@vkoul-udesk3>
Message-ID: <alpine.DEB.2.02.1208220837480.1966@localhost6.localdomain6>
References: <1344069330-29569-1-git-send-email-Julia.Lawall@lip6.fr>  <1345608994.1895.73.camel@vkoul-udesk3>  <CAGsJ_4yjzE3eNGz=AA7gGxGNkjBH8bKRAUsYXcG+A1p8PtOQPw@mail.gmail.com>  <alpine.DEB.2.02.1208220729440.1966@localhost6.localdomain6> 
 <CAGsJ_4wkyY7VkrgMwGwmFF4kpGiGEtU8Ox46G-yOspAi27Lqgg@mail.gmail.com> <1345617275.1895.83.camel@vkoul-udesk3>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> dmaengine: sirf: .............
> That is the usual way, it helps if you see the notation used by
> subsystem by checking patches being sent to subsystem, but it is not a
> really big deal, pls take care of this in future.

OK.

julia
