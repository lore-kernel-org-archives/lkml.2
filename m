Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2CZGB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 02:01:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:15417 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab2CZGBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 02:01:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="145335722"
Subject: Re: [PATCH v3 00/13] dmaengine: imx-dma: merge dma arch code into
 dmaengine.
From: Vinod Koul <vinod.koul@linux.intel.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: kernel@pengutronix.de, dan.j.williams@intel.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <CACKLOr0JTgp+poXCNg8+8pXko3s2JWQhovMw8Z1j-q4aL4oaKQ@mail.gmail.com>
References: <1331306449-28591-1-git-send-email-javier.martin@vista-silicon.com>
	 <1332344363.19804.12.camel@vkoul-udesk3>
	 <CACKLOr03tTymT1vdTH7=nqEHu3OvAinPUHEusK+mR+J6Yc35mQ@mail.gmail.com>
	 <CACKLOr0JTgp+poXCNg8+8pXko3s2JWQhovMw8Z1j-q4aL4oaKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Mar 2012 11:33:53 +0530
Message-ID: <1332741833.19804.17.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 15:11 +0100, javier Martin wrote:
> On 22 March 2012 10:39, javier Martin <javier.martin@vista-silicon.com> wrote:
> > On 21 March 2012 16:39, Vinod Koul <vinod.koul@linux.intel.com> wrote:
> >> This doesn't apply for me (starting with 6th) on current slave-dma.next
> >> due to obvious changes which have gone into imx.
> >>
> >> Can you quickly rebase the series and resend.
> >
> > Great,
> > now your 'next' branch is actually broken for imx-dma.
> >
> > I'm currently trying a bisect to find out what is the commit
> > responsible for that but I suspect it will be related to the cookie
> > changes submitted by Russell.
I had these in branch for quite some time for people to look and point
out any issues with merge.
> 
> Here,
> take a look at this series:
> 
> [PATCH v4 00/15] dmaengine: imx-dma: rebase of features for 3.4.
> 
> I've included a new fix patch which solves the merge issue.
Thanks Applied all, now
> 
> Regards.


-- 
~Vinod

