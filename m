Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2AZPdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 10:33:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50624 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab2AZPdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 10:33:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCHv19 00/15] Contiguous Memory Allocator
Date: Thu, 26 Jan 2012 15:31:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201261531.40551.arnd@arndb.de>
X-Provags-ID: V02:K0:YUUp3X7YQgT0AEWGLJBnrmRSYplQEAWKeCgJD+pzod9
 RMwHmemIdQa7Rh4QqW5MqgmO+v5FN/5Rso9Hsgb5Anqyk71ViQ
 h2eSg8J8HHoKWq71uuxz41MfoI7mYNFtYhap+ITTvbaIhmNNE7
 LK8s8hvMy2MgkFr6KmPFaTKnyPriNQPzhD+aj4AqLq2bpuphWM
 4VFKH8UVuXuOAl4g73CCLlifts6Jr2U/C+qGxPaJok4fxCeVOf
 GuPTRqUACphKoPUxv4Sm+FvMc8CDI1VeFeDSRHwwIls2OeGxWL
 tKJPbAs0TZAp4ErYRJz3BVsZpR5wXn6TN30WkAEFPVU6zTDdzF
 PHMsVzM2bv5L7EEF9ALQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 January 2012, Marek Szyprowski wrote:
> Welcome everyone!
> 
> Yes, that's true. This is yet another release of the Contiguous Memory
> Allocator patches. This version mainly includes code cleanups requested
> by Mel Gorman and a few minor bug fixes.

Hi Marek,

Thanks for keeping up this work! I really hope it works out for the
next merge window.

> TODO (optional):
> - implement support for contiguous memory areas placed in HIGHMEM zone
> - resolve issue with movable pages with pending io operations

Can you clarify these? I believe the contiguous memory areas in highmem
is something that should really be after the existing code is merged
into the upstream kernel and should better not be listed as TODO here.

I haven't followed the last two releases so closely. It seems that
in v17 the movable pages with pending i/o was still a major problem
but in v18 you added a solution. Is that right? What is still left
to be done here then?

	Arnd
