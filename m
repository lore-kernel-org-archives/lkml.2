Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab2JPMwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 08:52:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab2JPMw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 08:52:28 -0400
Message-ID: <507D5873.6010106@redhat.com>
Date: Tue, 16 Oct 2012 08:52:03 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        QEMU-devel <qemu-devel@nongnu.org>, KVM <kvm@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Arm Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] mm: compaction: Correct the nr_strict_isolated check
 for CMA
References: <20121016083927.GG29125@suse.de>
In-Reply-To: <20121016083927.GG29125@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 04:39 AM, Mel Gorman wrote:
> Thierry reported that the "iron out" patch for isolate_freepages_block()
> had problems due to the strict check being too strict with "mm: compaction:
> Iron out isolate_freepages_block() and isolate_freepages_range() -fix1".
> It's possible that more pages than necessary are isolated but the check
> still fails and I missed that this fix was not picked up before RC1. This
> same problem has been identified in 3.7-RC1 by Tony Prisk and should be
> addressed by the following patch.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Tested-by: Tony Prisk <linux@prisktech.co.nz>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
