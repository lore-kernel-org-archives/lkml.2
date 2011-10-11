Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167Ab1JKG6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 02:58:12 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10184 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab1JKG6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 02:58:10 -0400
Date: Tue, 11 Oct 2011 08:57:56 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCHv16 0/9] Contiguous Memory Allocator
In-reply-to: <20111010155642.38df59af.akpm@linux-foundation.org>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        "'Shariq Hasnain'" <shariq.hasnain@linaro.org>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Dave Hansen'" <dave@linux.vnet.ibm.com>
Message-id: <00af01cc87e3$1b05e980$5111bc80$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcyHn+WwzAZC4YasTRSwU+tDENsBMwAO+fVw
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
 <201110071827.06366.arnd@arndb.de>
 <20111010155642.38df59af.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, October 11, 2011 12:57 AM Andrew Morton wrote:

> On Fri, 7 Oct 2011 18:27:06 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Thursday 06 October 2011, Marek Szyprowski wrote:
> > > Once again I decided to post an updated version of the Contiguous Memory
> > > Allocator patches.
> > >
> > > This version provides mainly a bugfix for a very rare issue that might
> > > have changed migration type of the CMA page blocks resulting in dropping
> > > CMA features from the affected page block and causing memory allocation
> > > to fail. Also the issue reported by Dave Hansen has been fixed.
> > >
> > > This version also introduces basic support for x86 architecture, what
> > > allows wide testing on KVM/QEMU emulators and all common x86 boxes. I
> > > hope this will result in wider testing, comments and easier merging to
> > > mainline.
> >
> > Hi Marek,
> >
> > I think we need to finally get this into linux-next now, to get some
> > broader testing. Having the x86 patch definitely helps here becauses
> > it potentially exposes the code to many more testers.
> >
> > IMHO it would be good to merge the entire series into 3.2, since
> > the ARM portion fixes an important bug (double mapping of memory
> > ranges with conflicting attributes) that we've lived with for far
> > too long, but it really depends on how everyone sees the risk
> > for regressions here. If something breaks in unfixable ways before
> > the 3.2 release, we can always revert the patches and have another
> > try later.
> >
> > It's also not clear how we should merge it. Ideally the first bunch
> > would go through linux-mm, and the architecture specific patches
> > through the respective architecture trees, but there is an obvious
> > inderdependency between these sets.
> >
> > Russell, Andrew, are you both comfortable with putting the entire
> > set into linux-mm to solve this? Do you see this as 3.2 or rather
> > as 3.3 material?
> >
> 
> Russell's going to hate me, but...
> 
> I do know that he had substantial objections to at least earlier
> versions of this, and he is a guy who knows of what he speaks.

I've did my best to fix these issues. I'm still waiting for comments...

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

