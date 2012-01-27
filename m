Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab2A0O43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:56:29 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36840 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab2A0O42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:56:28 -0500
MIME-Version: 1.0
X-Originating-IP: [93.173.166.112]
In-Reply-To: <00de01ccdce1$e7c8a360$b759ea20$%szyprowski@samsung.com>
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
 <1327568457-27734-13-git-send-email-m.szyprowski@samsung.com>
 <CADMYwHw1B4RNV_9BqAg_M70da=g69Z3kyo5Cr6izCMwJ9LAtvA@mail.gmail.com> <00de01ccdce1$e7c8a360$b759ea20$%szyprowski@samsung.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 27 Jan 2012 16:56:07 +0200
Message-ID: <CAK=WgbY+TgjWcaKcEV-c6cQPN9qbjcmNzjEsTXXCjKoOZhO7FQ@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 12/15] drivers: add Contiguous Memory Allocator
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jesse Barker <jesse.barker@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/27 Marek Szyprowski <m.szyprowski@samsung.com>:
> I've tested it with 256MiB on Exynos4 platform. Could you check if the
> problem also appears on 3.2-cma-v19 branch (I've uploaded it a few hours
> ago)

Exactly what I needed, thanks :)

Both v18 and v19 seem to work fine with 3.2.

> The above code has not been changed since v16, so I'm really surprised
> that it causes problems. Maybe the memory configuration or layout has
> been changed in 3.3-rc1 for OMAP4?

Not sure what the culprit is, but it is only triggered with 3.3-rc1.

I'll tell you if I find anything.

Thanks!
Ohad.
