Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab2DJTel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 15:34:41 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:56888 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab2DJTej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 15:34:39 -0400
Message-ID: <4F848B4B.5000308@samsung.com>
Date: Tue, 10 Apr 2012 12:34:35 -0700
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Kukjin Kim <kgene.kim@samsung.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>,
        iommu@lists.linux-foundation.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v12 2/3] ARM: EXYNOS: Change System MMU platform device
 definitions
References: <000201cd0286$2e6fbb40$8b4f31c0$%cho@samsung.com> <20120315111227.GA2384@amd.com> <4F61FF1D.5000502@samsung.com> <4F630841.2070307@linaro.org> <4F63A6F6.9050506@samsung.com> <20120318132746.GL26973@8bytes.org>
In-Reply-To: <20120318132746.GL26973@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> On Fri, Mar 16, 2012 at 01:47:50PM -0700, Kukjin Kim wrote:
>> Anyway Joerg, how do you want to handle this? Do you want to pick up
>> 1/2/3 all of them in your tree? If so, 2nd patch should be on top of
>> some samsung topic stuff.
>
> Since patch 2 only applies to the Samsung tree, it is best to carry
> this in your tree for merging. Feel free to add my Acked-by to patch 3.
> But any further patches for the Exynos IOMMU drivers should go through
> my tree after it is merged.
>
Hi Joerg,

I applied 1st and 2nd patches in my tree.

git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git 
next/cleanup-samsung-iommu

and my -next.

So please go ahead for 3rd patch in your tree. Note that if you need 1st 
and 2nd patches for your tree, please merge the 
'next/cleanup-samsung-iommu' branch in my tree. If not, will happen 
useless conflicts.

If any problems, please let me know.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
