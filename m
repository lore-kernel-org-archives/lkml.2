Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab2ABPVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 10:21:38 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43124 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606Ab2ABPVd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 10:21:33 -0500
MIME-Version: 1.0
In-Reply-To: <20120102134229.GZ29877@amd.com>
References: <000e01ccc624$c9349310$5b9db930$%cho@samsung.com>
	<20120102134229.GZ29877@amd.com>
Date: Tue, 3 Jan 2012 00:21:30 +0900
X-Google-Sender-Auth: LhlfQP-wBiruV5UNP2FQEGFiCqQ
Message-ID: <CAHQjnON3XYZ9cAK0kqsY4QzMzESD1wOzxt-fiQCq3TJfDObFiw@mail.gmail.com>
Subject: Re: [PATCH v8 0/2] ommu/exynos: Add IOMMU/System MMU driver for
 Samsung Exynos
From: KyongHo Cho <pullip.cho@samsung.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        linux-kernel@vger.kernel.org,
        Younglak Kim <younglak1004.kim@samsung.com>,
        iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
On Mon, Jan 2, 2012 at 10:42 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> Hi,
>
> On Thu, Dec 29, 2011 at 09:24:18PM +0900, KyongHo Cho wrote:
>> Changes since v7:
>> - Rebased with the recent commits of the following git branches
>>   * git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/next
>>   * git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git/for-next
>> - Changed magic numbers into macros
>> - Setting owner of a System MMU in 'iommu' field of dev_archdata
>> - Verbose message in the default fault handler
>> - Some bug fixes.
>
> I still get
>
>  LD      .tmp_vmlinux1
> /data/cross/gcc-4.6.0-nolibc/arm-unknown-linux-gnueabi/bin/arm-unknown-linux-gnueabi-ld: no machine record defined
> /data/cross/gcc-4.6.0-nolibc/arm-unknown-linux-gnueabi/bin/arm-unknown-linux-gnueabi-ld: no machine record defined
> /data/cross/gcc-4.6.0-nolibc/arm-unknown-linux-gnueabi/bin/arm-unknown-linux-gnueabi-ld: no machine record defined
> make[1]: *** [.tmp_vmlinux1] Error 1
>
> when trying to compile ARM/Exynos with 3.2-rc7. Am I doing something
> wrong or is this not expected to work?
>
Do you?
Ok. I will check my configuration with linux-next git.

Thank you.

KyongHo
