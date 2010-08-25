Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab0HYX0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:26:54 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3315 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab0HYX0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:26:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6085"; a="52115974"
Subject: Re: [PATCH/RFCv4 0/6] The Contiguous Memory Allocator framework
From: Daniel Walker <dwalker@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>, linux-mm@kvack.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hans Verkuil <hverkuil@xs4all.nl>, Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20100825155814.25c783c7.akpm@linux-foundation.org>
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
	 <1282310110.2605.976.camel@laptop>
	 <20100825155814.25c783c7.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 16:26:34 -0700
Message-ID: <1282778794.13797.15.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 15:58 -0700, Andrew Morton wrote:
> That would be good.  Although I expect that the allocation would need
> to be 100% rock-solid reliable, otherwise the end user has a
> non-functioning device.  Could generic core VM provide the required
> level
> of service?
> 
> Anyway, these patches are going to be hard to merge but not
> impossible.
> Keep going.  Part of the problem is cultural, really: the consumers of
> this interface are weird dinky little devices which the core MM guys
> tend not to work with a lot, and it adds code which they wouldn't use.
> 
> I agree that having two "contiguous memory allocators" floating about
> on the list is distressing.  Are we really all 100% diligently certain
> that there is no commonality here with Zach's work?

There is some commonality with Zach's work, but Zach should be following
all of this development .. So presumably he has no issues with Michal's
changes. I think Zach's solution has a similar direction to this.

If Michal is active (he seems more so than Zach), and follows community
comments (including Zach's , but I haven't seen any) then we can defer
to that solution ..

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

