Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab2DTScD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 14:32:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:54173 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab2DTSb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 14:31:59 -0400
Subject: Re: [PATCHv24 00/16] Contiguous Memory Allocator
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20120419124044.632bfa49.akpm@linux-foundation.org>
Date: Fri, 20 Apr 2012 13:31:12 -0500
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Rob Clark <rob.clark@linaro.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Sandeep Patil <psandeep.s@gmail.com>
Content-Transfer-Encoding: 7bit
Message-Id: <4C95F6F5-3B10-42FE-92B7-C1E8AE6A1820@kernel.crashing.org>
References: <1333462221-3987-1-git-send-email-m.szyprowski@samsung.com> <20120419124044.632bfa49.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 19, 2012, at 2:40 PM, Andrew Morton wrote:

> On Tue, 03 Apr 2012 16:10:05 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> 
>> This is (yet another) update of CMA patches.
> 
> Looks OK to me.  It's a lot of code.
> 
> Please move it into linux-next, and if all is well, ask Linus to pull
> the tree into 3.5-rc1.  Please be sure to cc me on that email.
> 
> I suggest that you include additional patches which enable CMA as much
> as possible on as many architectures as possible so that it gets
> maximum coverage testing in linux-next.  Remove those Kconfig patches
> when merging upstream.
> 
> All this code will probably mess up my tree, but I'll work that out. 
> It would be more awkward if the CMA code were to later disappear from
> linux-next or were not merged into 3.5-rc1.  Let's avoid that.

I'm looking at the patches to see if I can contribute arch support for PPC.

- k
