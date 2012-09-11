Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498Ab2IKS40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:56:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:31814 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759171Ab2IKS4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:56:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,406,1344236400"; 
   d="scan'208";a="201691214"
Date: Tue, 11 Sep 2012 20:56:18 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Bill Huang <bilhuang@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Xin Xie <xxie@nvidia.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "jhovold@gmail.com" <jhovold@gmail.com>,
        "kyle.manna@fuel7.com" <kyle.manna@fuel7.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] mfd: dt: add power off support for Tegra20/Tegra30
Message-ID: <20120911185618.GX3647@sortiz-mobl>
References: <1345424876-4365-1-git-send-email-bilhuang@nvidia.com>
 <A7051F87A141B744BCAF487D48E5B3BDF5BBE83B1A@HKMAIL02.nvidia.com>
 <20120911104635.GB28904@avionic-0098.mockup.avionic-design.de>
 <504F557B.9020600@wwwdotorg.org>
 <20120911160811.GU3647@sortiz-mobl>
 <504F664F.8040803@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504F664F.8040803@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 10:26:55AM -0600, Stephen Warren wrote:
> On 09/11/2012 10:08 AM, Samuel Ortiz wrote:
> > Hi Stephen,
> > 
> > On Tue, Sep 11, 2012 at 09:15:07AM -0600, Stephen Warren wrote:
> >> On 09/11/2012 04:46 AM, Thierry Reding wrote:
> >>> On Tue, Sep 11, 2012 at 06:25:14PM +0800, Bill Huang wrote:
> >>>> Hi all,
> >>>>
> >>>> Could somebody review this?
> >>>
> >>> Given that I haven't been able to test yet (due to time
> >>> constraints) with PM_SLEEP_SMP enabled, I don't want to give you a
> >>> Tested-by, but the code looks okay to me, so for both patches:
> >>>
> >>> Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> >>
> >> I have tested this with PM_SLEEP_SMP enabled, and it solved the
> >> problem. I think I already gave my Tested-by, but if not:
> >>
> >> Tested-by: Stephen Warren <swarren@wwwdotorg.org>
> >>
> >> I hope that this gets applied to the MFD tree early enough (i.e.
> >> within the next 2-3 days or so) that I can rely on the binding be
> >> accepted, and hence apply patches to Tegra's device tree to enable
> >> this functionality for 3.7.
> >>
> >> Bill, given this was posted about 3 weeks ago, perhaps repost the
> >> series in case Samuel doesn't have it any more, and hence can't apply it.
> >
> > No need for that. Sorry for the delay, I just applied and pushed those 2
> > patches.
> 
> Great! Thanks.
> 
> Do you have "[PATCH V4 REPOST] mfd: add MAX8907 core driver" on your
> list too?
Yes, I'll be chewing my MFD pending patches list in the next days, and this
one is on the list.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
