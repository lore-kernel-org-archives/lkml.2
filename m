Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab2JPNMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 09:12:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65028 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab2JPNMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 09:12:33 -0400
Date: Tue, 16 Oct 2012 22:12:28 +0900
From: Minchan Kim <minchan@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, QEMU-devel <qemu-devel@nongnu.org>,
        KVM <kvm@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arm Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] mm: compaction: Correct the nr_strict_isolated check for
 CMA
Message-ID: <20121016131228.GB5603@barrios>
References: <20121016083927.GG29125@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016083927.GG29125@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 09:39:27AM +0100, Mel Gorman wrote:
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
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind Regards,
Minchan Kim
