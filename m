Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1LTXiC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:38:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab1LTXh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:37:59 -0500
Date: Tue, 20 Dec 2011 15:37:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: kosaki.motohiro@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Caspar Zhang <caspar@casparzhang.com>,
        Stephen Wilson <wilsons@start.ca>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] [v2] mempolicy: refix mbind_range() vma issue
Message-Id: <20111220153757.8d80af1e.akpm@linux-foundation.org>
In-Reply-To: <20111220192850.GB3870@cmpxchg.org>
References: <20111212112000.GB18789@cmpxchg.org>
	<1324405032-22281-1-git-send-email-kosaki.motohiro@gmail.com>
	<20111220192850.GB3870@cmpxchg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Dec 2011 20:28:50 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Minchan Kim <minchan.kim@gmail.com>
> > CC: Caspar Zhang <caspar@casparzhang.com>
> 
> Looks good to me now, thanks.
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Since this can corrupt virtual mappings and was released with 3.2, I
> think we also want this:
> 
> Cc: stable@kernel.org [3.2.x]

I assume you meant 3.1.x  And into mainline for 3.2?
