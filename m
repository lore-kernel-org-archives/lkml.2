Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab2ADPBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:01:18 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:49660
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755835Ab2ADPBN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:01:13 -0500
X-SpamScore: -23
X-BigFish: VPS-23(zz1432N98dK4015Lzz1202hzz15d4Rz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,13,
X-WSS-ID: 0LXA4DO-02-BZM-02
X-M-MSG: 
Date: Wed, 4 Jan 2012 16:01:01 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: KyongHo Cho <pullip.cho@samsung.com>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 0/2] ommu/exynos: Add IOMMU/System MMU driver for
 Samsung Exynos
Message-ID: <20120104150101.GA3492@amd.com>
References: <000e01ccc624$c9349310$5b9db930$%cho@samsung.com>
 <20120102134229.GZ29877@amd.com>
 <CAHQjnON3XYZ9cAK0kqsY4QzMzESD1wOzxt-fiQCq3TJfDObFiw@mail.gmail.com>
 <20120102155820.GB29877@amd.com>
 <20120103095527.GI2914@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20120103095527.GI2914@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 09:55:27AM +0000, Russell King - ARM Linux wrote:
> On Mon, Jan 02, 2012 at 04:58:20PM +0100, Joerg Roedel wrote:
> > On Tue, Jan 03, 2012 at 12:21:30AM +0900, KyongHo Cho wrote:
> > > > I still get
> > > >
> > > >  LD      .tmp_vmlinux1
> > > > /data/cross/gcc-4.6.0-nolibc/arm-unknown-linux-gnueabi/bin/arm-unknown-linux-gnueabi-ld: no machine record defined
> > > > /data/cross/gcc-4.6.0-nolibc/arm-unknown-linux-gnueabi/bin/arm-unknown-linux-gnueabi-ld: no machine record defined
> > > > /data/cross/gcc-4.6.0-nolibc/arm-unknown-linux-gnueabi/bin/arm-unknown-linux-gnueabi-ld: no machine record defined
> > > > make[1]: *** [.tmp_vmlinux1] Error 1
> > > >
> > > > when trying to compile ARM/Exynos with 3.2-rc7. Am I doing something
> > > > wrong or is this not expected to work?
> > > >
> > > Do you?
> > > Ok. I will check my configuration with linux-next git.
> > 
> > Compiling my exynos-config with linux-next gives me:
> > 
> >   CC      arch/arm/kernel/process.o
> > In file included from /data/lemmy/linux.trees.git/arch/arm/mach-exynos/include/mach/system.h:16:0,
> >                  from /data/lemmy/linux.trees.git/arch/arm/kernel/process.c:64:
> > /data/lemmy/linux.trees.git/arch/arm/plat-samsung/include/plat/system-reset.h:19:2: error: #error Fix me up
> > 
> > I better not ask the question how such an #error statement can come
> > through to linux-next.
> 
> It comes through when I stick it in my tree because of a month of asking
> for help to fix something and getting zero response from the maintainers.
> 
> It's a way to flag to them that they're doing something wrong - and in
> fact something is broken, and that that brokenness will happen at the
> next merge window unless they get off their butt and do something about
> it.

Okay, fine with me if it really will be fixed in 3.3-rc1 :)

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

