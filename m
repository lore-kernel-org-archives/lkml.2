Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab2ACJhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 04:37:37 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19722 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2ACJhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 04:37:35 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Tue, 03 Jan 2012 10:37:29 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH v8 0/2] ommu/exynos: Add IOMMU/System MMU driver for
 Samsung Exynos
In-reply-to: <20120102134229.GZ29877@amd.com>
To: "'Joerg Roedel'" <joerg.roedel@amd.com>,
        "'KyongHo Cho'" <pullip.cho@samsung.com>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        linux-kernel@vger.kernel.org,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>,
        iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Message-id: <00dc01ccc9fb$4fcb7590$ef6260b0$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: AczJVPtzFl+r3KYxSrSvBlXHG3+C+QApQGMw
References: <000e01ccc624$c9349310$5b9db930$%cho@samsung.com>
 <20120102134229.GZ29877@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Monday, January 02, 2012 2:42 PM Joerg Roedel wrote:

> On Thu, Dec 29, 2011 at 09:24:18PM +0900, KyongHo Cho wrote:
> > Changes since v7:
> > - Rebased with the recent commits of the following git branches
> >   * git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/next
> >   * git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git/for-next
> > - Changed magic numbers into macros
> > - Setting owner of a System MMU in 'iommu' field of dev_archdata
> > - Verbose message in the default fault handler
> > - Some bug fixes.
> 
> I still get
> 
>   LD      .tmp_vmlinux1
> /data/cross/gcc-4.6.0-nolibc/arm-unknown-linux-gnueabi/bin/arm-unknown-linux-gnueabi-ld: no
> machine record defined
> /data/cross/gcc-4.6.0-nolibc/arm-unknown-linux-gnueabi/bin/arm-unknown-linux-gnueabi-ld: no
> machine record defined
> /data/cross/gcc-4.6.0-nolibc/arm-unknown-linux-gnueabi/bin/arm-unknown-linux-gnueabi-ld: no
> machine record defined
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> when trying to compile ARM/Exynos with 3.2-rc7. Am I doing something
> wrong or is this not expected to work?

Yes, there is something a bit wrong with your kernel configuration. You get this error if 
there is no board selected to be compiled-in. Please go to kernel configuration and select
"System Type -> SAMSUNG EXYNOS SoCs Suppport". Then select some hardware board to be 
compiled in, for example SMDKV310, SMDKC210 and "Mobile NURI board".

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


