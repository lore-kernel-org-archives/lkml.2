Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab1KRKT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:19:56 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60693 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab1KRKTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:19:55 -0500
MIME-Version: 1.0
In-Reply-To: <1321527667-12923-1-git-send-email-hdoyu@nvidia.com>
References: <1321527667-12923-1-git-send-email-hdoyu@nvidia.com>
Date: Fri, 18 Nov 2011 19:19:53 +0900
X-Google-Sender-Auth: b8vHBZphaEPYbvjHPNCCyBGyYeo
Message-ID: <CAHQjnOM-N9suPrv_nSRQsxGCNrf77rFLNtRcOdsjyz_O6bGdpA@mail.gmail.com>
Subject: Re: [PATCH 0/3] ARM: iommu: tegra: Add initial Tegra IOMMU driver
From: KyongHo Cho <pullip.cho@samsung.com>
To: hdoyu@nvidia.com
Cc: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 8:01 PM,  <hdoyu@nvidia.com> wrote:
>
> Hiroshi DOYU (3):
>  ARM: iommu: tegra/common: Initial support for IOVMM driver
>  ARM: iommu: tegra2: Initial support for GART driver
>  ARM: iommu: tegra3: Initial support for SMMU driver
>

Hi.

I found that those patches are not IOMMU API implementations.
I wonder why they need to be located in drivers/iommu?

Regards,

  KyongHo
