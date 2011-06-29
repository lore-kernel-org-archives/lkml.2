Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab1F2FCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 01:02:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56505 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab1F2FCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 01:02:06 -0400
MIME-Version: 1.0
In-Reply-To: <1308843083-10442-1-git-send-email-joerg.roedel@amd.com>
References: <1308843083-10442-1-git-send-email-joerg.roedel@amd.com>
Date: Wed, 29 Jun 2011 14:02:02 +0900
X-Google-Sender-Auth: owww8eafE9gpPxFpOSf9xLR14RA
Message-ID: <BANLkTi=mfMfVVOmoZd49fqFnY_kq0hxzDw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Introduce iommu_commit() function
From: KyongHo Cho <pullip.cho@samsung.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, David Brown <davidb@codeaurora.org>,
        kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, Jun 24, 2011 at 12:31 AM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> It needs to be called whenever a some code changed a domain (either by
> attaching/detaching devices or by mapping/unmapping pages in
> the domain).

Do you mean we can invalidate IOTLB with this iommu_commit()?
We need to invalidate IOTLB without updating page table for some
optimized solutions.

If a device in one domain is moved to other domain, IOTLB of the
device must be invalidated
because it contains translation information of the previous domain.

Regards,
KyongHo Cho.
