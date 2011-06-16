Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab1FPRBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 13:01:41 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53042 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1FPRBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 13:01:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6378"; a="97958294"
Date: Thu, 16 Jun 2011 10:01:33 -0700
From: Larry Bassel <lbassel@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Larry Bassel <lbassel@codeaurora.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Zach Pfeffer'" <zach.pfeffer@linaro.org>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Daniel Stone'" <daniels@collabora.com>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous Memory
 Allocator added
Message-ID: <20110616170133.GC28032@labbmf-linux.qualcomm.com>
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>
 <000901cc2b37$4c21f030$e465d090$%szyprowski@samsung.com>
 <20110615213958.GB28032@labbmf-linux.qualcomm.com>
 <201106160006.07742.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106160006.07742.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 Jun 11 00:06, Arnd Bergmann wrote:
> On Wednesday 15 June 2011 23:39:58 Larry Bassel wrote:
> > On 15 Jun 11 10:36, Marek Szyprowski wrote:
> > > On Tuesday, June 14, 2011 10:42 PM Arnd Bergmann wrote:
> > > 
> > > > On Tuesday 14 June 2011 20:58:25 Zach Pfeffer wrote:
> > > > > I've seen this split bank allocation in Qualcomm and TI SoCs, with
> > > > > Samsung, that makes 3 major SoC vendors (I would be surprised if
> > > > > Nvidia didn't also need to do this) - so I think some configurable
> > > > > method to control allocations is necessarily. The chips can't do
> > > > > decode without it (and by can't do I mean 1080P and higher decode is
> > > > > not functionally useful). Far from special, this would appear to be
> > > > > the default.
> > 
> > We at Qualcomm have some platforms that have memory of different
> > performance characteristics, some drivers will need a way of
> > specifying that they need fast memory for an allocation (and would prefer
> > an error if it is not available rather than a fallback to slower
> > memory). It would also be bad if allocators who don't need fast
> > memory got it "accidentally", depriving those who really need it.
> 
> Can you describe how the memory areas differ specifically?
> Is there one that is always faster but very small, or are there
> just specific circumstances under which some memory is faster than
> another?

One is always faster, but very small (generally 2-10% the size
of "normal" memory).

Larry

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
