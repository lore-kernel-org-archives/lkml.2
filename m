Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab1FGPMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:12:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54609 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1FGPMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:12:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P9m4BMOEu7ect4A2q3xdlyqoH1Wb4PfF/NEftVHpBUlJ+0SnC9j91NKllT4c6kTN5b
         hixZGBCrMQEZx0BhpGavKkIGWdcgPMIoYnJlrXO3IGjecQyv8Ni+NDq7T3rOrxCrjUNR
         xS62tf8UEVdW1n9KqJobFOWe6fu4769jgRqA8=
Date: Wed, 8 Jun 2011 00:12:42 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Sattler <tsattler@gmx.de>, Ury Stankevich <urykhy@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] mm: vmscan: Do not use page_count without a page
 pin
Message-ID: <20110607151242.GI1686@barrios-laptop>
References: <1307459225-4481-1-git-send-email-mgorman@suse.de>
 <1307459225-4481-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307459225-4481-3-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 04:07:03PM +0100, Mel Gorman wrote:
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> It is unsafe to run page_count during the physical pfn scan because
> compound_head could trip on a dangling pointer when reading
> page->first_page if the compound page is being freed by another CPU.
> 
> [mgorman@suse.de: Split out patch]
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards
Minchan Kim
