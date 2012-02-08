Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab2BHPiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 10:38:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34839 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab2BHPiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 10:38:07 -0500
Date: Wed, 8 Feb 2012 16:38:01 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        xiyou.wangcong@gmail.com, penberg@kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] selftests: Launch individual selftests from the main
 Makefile
Message-ID: <20120208153759.GD25473@somewhere.redhat.com>
References: <20120205081555.GA2249@darkstar.redhat.com>
 <20120206155340.b9075240.akpm@linux-foundation.org>
 <20120208034055.GA23894@somewhere.redhat.com>
 <alpine.DEB.2.00.1202080843250.29839@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202080843250.29839@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 08:45:35AM -0600, Christoph Lameter wrote:
> Note that slub also has an embedded selftest (see function
> resiliency_test). That code could be separated out and put with the
> selftests that you are creating now.

That would be nice. As long as it's in userspace and it runs validation
tests, it's pretty welcome.

It's deemed to test expected behaviour with deterministic tests. stress tests
probably don't fit well there although it should be no problem if they are short.


> I also have a series of in kernel benchmarks for the page allocation, vm
> statistics and slab allocators that could be useful to included somewhere.
> 
> All this code runs in the kernel context.
> 
> For the in kernel benchmarks I am creating modules that fail to load but
> first run the tests.

Hmm, benchmarks tend to require some user analysis, I'm not sure if a batch of
validation tests is the right place for them. But loading modules is probably
not a problem.
