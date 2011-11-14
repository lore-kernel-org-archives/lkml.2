Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1KNNdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 08:33:44 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34886 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab1KNNdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 08:33:44 -0500
Date: Mon, 14 Nov 2011 13:35:13 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Joerg Roedel <joerg.roedel@amd.com>
cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH] iommu/intel: Fix build failure with intel-gtt and
 !intel-iommu
In-Reply-To: <20111114132647.GD14704@amd.com>
Message-ID: <alpine.DEB.2.00.1111141334340.8973@skynet.skynet.ie>
References: <20111111134832.GI13213@amd.com> <1321019553.2027.47.camel@shinybook.infradead.org> <20111114132647.GD14704@amd.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> 
> > But I'm fairly sure this was already noticed and a patch is on its way
> > upstream already.
> 
> It is not yet fixed upstream. I plan to send fixes to Linus soon. Any
> objection against me including this if its not fixed until then?

Does a08185a3eb658854b29c05bcbfac0f85038ffe9f in Linus tree not fix it?

Dave.
