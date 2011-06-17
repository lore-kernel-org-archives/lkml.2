Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845Ab1FQMrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 08:47:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52100 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757823Ab1FQMrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 08:47:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Larry Bassel <lbassel@codeaurora.org>
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous Memory Allocator added
Date: Fri, 17 Jun 2011 14:45:09 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
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
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com> <201106160006.07742.arnd@arndb.de> <20110616170133.GC28032@labbmf-linux.qualcomm.com>
In-Reply-To: <20110616170133.GC28032@labbmf-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171445.09567.arnd@arndb.de>
X-Provags-ID: V02:K0:LXZnuzQGmoKMgZ2TtFL0PCGciF2RjdiPvN8d6wowUQd
 0yZ+u5BTzQzROWbTQulFy3CNQ2WxhDiPOEM1ppzhdS7t0IftLa
 KtZr1HlJQc9y164OaW8BCcPKqmlfllWWh/CFSYSMa1RzWg7hWe
 kRf85/6WguZCDJC1DqScjI7vJE7pv+5tRKwjt7R+Fxi9D3Y3yc
 XtmLevoqzF1p3QOqyp77g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 June 2011 19:01:33 Larry Bassel wrote:
> > Can you describe how the memory areas differ specifically?
> > Is there one that is always faster but very small, or are there
> > just specific circumstances under which some memory is faster than
> > another?
> 
> One is always faster, but very small (generally 2-10% the size
> of "normal" memory).
> 

Ok, that sounds like the "SRAM" regions that we are handling on some
ARM platforms using the various interfaces. It should probably
remain outside of the regular allocator, but we can try to generalize
the SRAM support further. There are many possible uses for it.

	Arnd
