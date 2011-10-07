Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965447Ab1JGLhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:37:10 -0400
Received: from 8bytes.org ([88.198.83.132]:39103 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965366Ab1JGLhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:37:09 -0400
Date: Fri, 7 Oct 2011 13:37:01 +0200
From: Joerg Roedel <joro@8bytes.org>
To: KyongHo Cho <pullip.cho@samsung.com>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>, Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        "younglak1004.kim@samsung.com" <younglak1004.kim@samsung.com>
Subject: Re: [PATCH v2 5/5] iommu/exynos: Use bus_set_iommu instead of
	register_iommu
Message-ID: <20111007113701.GC1512@8bytes.org>
References: <017001cc7f43$04a2db60$0de89220$%kim@samsung.com> <20110930134643.GS2138@amd.com> <CAHQjnOPiAOA_RiHnF-aVEYnWcdkwNzVD1BTNua+-ztZrW_+6_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQjnOPiAOA_RiHnF-aVEYnWcdkwNzVD1BTNua+-ztZrW_+6_A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 08:52:45AM +0900, KyongHo Cho wrote:
> On Fri, Sep 30, 2011 at 10:46 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> > On Fri, Sep 30, 2011 at 03:31:49AM -0400, Kukjin Kim wrote:
> >> From: KyongHo Cho <pullip.cho@samsung.com>
> >>
> >> This replaces register_iommu() with bus_set_iommu() according to the
> >> suggestion of Joerg Roedel.
> >
> > This should be part of patch 3 already when the bus_set_iommu() change
> > is merged. Otherwise it breaks bisectability too.
> >
> Ok.
> Should I include fault handling feature (patch 4) in the patch 3 also?

Yes, makes sense to include patch 4 too.

