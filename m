Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab1GFOs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 10:48:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43092 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab1GFOs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 10:48:56 -0400
Date: Wed, 6 Jul 2011 10:37:37 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Arnd Bergmann <arnd@arndb.de>, "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>, "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 6/8] drivers: add Contiguous Memory
 Allocator
In-Reply-To: <20110706142345.GC8286@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1107061034200.14596@xanadu.home>
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <20110705113345.GA8286@n2100.arm.linux.org.uk> <006301cc3be4$daab1850$900148f0$%szyprowski@samsung.com> <201107061609.29996.arnd@arndb.de>
 <20110706142345.GC8286@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jul 2011, Russell King - ARM Linux wrote:

> Another issue is that when a platform has restricted DMA regions,
> they typically don't fall into the highmem zone.  As the dmabounce
> code allocates from the DMA coherent allocator to provide it with
> guaranteed DMA-able memory, that would be rather inconvenient.

Do we encounter this in practice i.e. do those platforms requiring large 
contiguous allocations motivating this work have such DMA restrictions?


Nicolas
