Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab2DJNod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:44:33 -0400
Received: from smtp.nokia.com ([147.243.128.26]:39872 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab2DJNoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:44:32 -0400
Date: Tue, 10 Apr 2012 16:41:37 +0300 (EEST)
From: Aaro Koskinen <aaro.koskinen@nokia.com>
X-X-Sender: aakoskin@kernel.research.nokia.com
To: Marek Szyprowski <m.szyprowski@samsung.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sandeep Patil <psandeep.s@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jesse Barker <jesse.barker@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Clark <rob.clark@linaro.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCHv24 00/16] Contiguous Memory Allocator
In-Reply-To: <1333462221-3987-1-git-send-email-m.szyprowski@samsung.com>
Message-ID: <alpine.DEB.2.00.1204101528390.9354@kernel.research.nokia.com>
References: <1333462221-3987-1-git-send-email-m.szyprowski@samsung.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 3 Apr 2012, Marek Szyprowski wrote:
> This is (yet another) update of CMA patches.

How well CMA is supposed to work if you have mlocked processes? I've
been testing these patches, and noticed that by creating a small mlocked
process you start to get plenty of test_pages_isolated() failure warnings,
and bigger allocations will always fail.

A.
