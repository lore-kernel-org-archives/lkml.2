Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab2AIAcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 19:32:16 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43811 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754876Ab2AIAcP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 19:32:15 -0500
MIME-Version: 1.0
In-Reply-To: <20120105114732.GA7166@amd.com>
References: <000e01ccc624$c9349310$5b9db930$%cho@samsung.com>
	<20120102134229.GZ29877@amd.com>
	<CAHQjnON3XYZ9cAK0kqsY4QzMzESD1wOzxt-fiQCq3TJfDObFiw@mail.gmail.com>
	<20120102155820.GB29877@amd.com>
	<20120103095527.GI2914@n2100.arm.linux.org.uk>
	<20120104150101.GA3492@amd.com>
	<20120104212620.GG11810@n2100.arm.linux.org.uk>
	<20120105114732.GA7166@amd.com>
Date: Mon, 9 Jan 2012 09:32:12 +0900
X-Google-Sender-Auth: f2amtaFIsueK_L4VDtT80TW3M-E
Message-ID: <CAHQjnOPB=APDXvDosWbEfas0-CKmBf-ATivfkOFOGYP9iGdbtw@mail.gmail.com>
Subject: Re: [PATCH v8 0/2] ommu/exynos: Add IOMMU/System MMU driver for
 Samsung Exynos
From: KyongHo Cho <pullip.cho@samsung.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 8:47 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> On Wed, Jan 04, 2012 at 09:26:20PM +0000, Russell King - ARM Linux wrote:
>> On Wed, Jan 04, 2012 at 04:01:01PM +0100, Joerg Roedel wrote:
>> > On Tue, Jan 03, 2012 at 09:55:27AM +0000, Russell King - ARM Linux wrote:
>> > > It comes through when I stick it in my tree because of a month of asking
>> > > for help to fix something and getting zero response from the maintainers.
>> > >
>> > > It's a way to flag to them that they're doing something wrong - and in
>> > > fact something is broken, and that that brokenness will happen at the
>> > > next merge window unless they get off their butt and do something about
>> > > it.
>> >
>> > Okay, fine with me if it really will be fixed in 3.3-rc1 :)
>>
>> I can do better than that - and report that it's fixed now.  It should
>> show up in linux-next sometime after Stephen pulls this evening.  The
>> #error did its job in this case, and ensured that it got fixed!
>
> Great. So it looks like I can finally compile-test Exynos and merge
> their IOMMU driver after the merge window :)
>

Thanks to you, Marek and Russell for helps to compile the driver.

I've learned many things from you.

Regards,

KyongHo.
