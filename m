Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab2ADV0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 16:26:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47676 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2ADV0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 16:26:38 -0500
Date: Wed, 4 Jan 2012 21:26:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: KyongHo Cho <pullip.cho@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 0/2] ommu/exynos: Add IOMMU/System MMU driver for
	Samsung Exynos
Message-ID: <20120104212620.GG11810@n2100.arm.linux.org.uk>
References: <000e01ccc624$c9349310$5b9db930$%cho@samsung.com> <20120102134229.GZ29877@amd.com> <CAHQjnON3XYZ9cAK0kqsY4QzMzESD1wOzxt-fiQCq3TJfDObFiw@mail.gmail.com> <20120102155820.GB29877@amd.com> <20120103095527.GI2914@n2100.arm.linux.org.uk> <20120104150101.GA3492@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104150101.GA3492@amd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 04:01:01PM +0100, Joerg Roedel wrote:
> On Tue, Jan 03, 2012 at 09:55:27AM +0000, Russell King - ARM Linux wrote:
> > It comes through when I stick it in my tree because of a month of asking
> > for help to fix something and getting zero response from the maintainers.
> > 
> > It's a way to flag to them that they're doing something wrong - and in
> > fact something is broken, and that that brokenness will happen at the
> > next merge window unless they get off their butt and do something about
> > it.
> 
> Okay, fine with me if it really will be fixed in 3.3-rc1 :)

I can do better than that - and report that it's fixed now.  It should
show up in linux-next sometime after Stephen pulls this evening.  The
#error did its job in this case, and ensured that it got fixed!
