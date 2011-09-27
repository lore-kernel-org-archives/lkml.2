Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab1I0I4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 04:56:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48474 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab1I0I4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 04:56:34 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.46.211]
In-Reply-To: <1316195506-9777-1-git-send-email-ohad@wizery.com>
References: <1316195506-9777-1-git-send-email-ohad@wizery.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 27 Sep 2011 11:56:13 +0300
Message-ID: <CAK=WgbYkG7s+aLW2icm0iHbiX1YRSZ1JSr=jPDv=3Dd+Fg1wgg@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] iommu: split mapping to page sizes as supported by
 the hardware
To: iommu@lists.linux-foundation.org, Joerg Roedel <Joerg.Roedel@amd.com>
Cc: linux-omap@vger.kernel.org, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping

On Fri, Sep 16, 2011 at 8:51 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> v2->v3:
>
> - s/KB/KiB/ (David W)
>
> v1->v2:
>
> - split to patches (by keeping the old code around until all drivers are converted) (Joerg)
>
>
> Ohad Ben-Cohen (6):
>  iommu/core: split mapping to page sizes as supported by the hardware
>  iommu/omap: announce supported page sizes
>  iommu/msm: announce supported page sizes
>  iommu/amd: announce supported page sizes
>  iommu/intel: announce supported page sizes
>  iommu/core: remove the temporary register_iommu_pgsize API
>
>  drivers/iommu/amd_iommu.c   |   20 ++++++-
>  drivers/iommu/intel-iommu.c |   20 ++++++-
>  drivers/iommu/iommu.c       |  130 +++++++++++++++++++++++++++++++++++++++----
>  drivers/iommu/msm_iommu.c   |    8 ++-
>  drivers/iommu/omap-iommu.c  |    6 ++-
>  drivers/iommu/omap-iovmm.c  |   12 +---
>  include/linux/iommu.h       |    7 +-
>  virt/kvm/iommu.c            |    4 +-
>  8 files changed, 177 insertions(+), 30 deletions(-)
>
> --
> 1.7.4.1
>
>
