Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab0EUCKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 22:10:35 -0400
Received: from smtp-out.google.com ([74.125.121.35]:37175 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab0EUCKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 22:10:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=nIrZ4S4LR6hkARKm38qOWZdWBpXaxv/YRNVcY3inSdS9x6JhnR+ZA4JCGU8BRKipr
	O8woVq+go8KvDTqaEuh+Q==
Date: Thu, 20 May 2010 19:10:19 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Shaohua Li <shaohua.li@intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tmpfs: Insert tmpfs cache pages to inactive list at
 first
In-Reply-To: <20100521103935.1E56.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.00.1005201859260.23122@tigran.mtv.corp.google.com>
References: <20100519174327.9591.A69D9226@jp.fujitsu.com> <alpine.DEB.1.00.1005201822120.19421@tigran.mtv.corp.google.com> <20100521103935.1E56.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010, KOSAKI Motohiro wrote:
> 
> > Acked-by: Hugh Dickins <hughd@google.com>
> > 
> > Thanks - though I don't quite agree with your description: I can't
> > see why the lru_cache_add_active_anon() was ever justified - that
> > "active" came in along with the separate anon and file LRU lists.
> 
> If you have any worry, can you please share it? I'll test such workload
> and fix the issue if necessary. You are expert than me in this area.

?? I've acked the patch: my worry is only with the detail of your
comments on the history - in my view it was always wrong to put on
the active LRU there, and I'm glad that you have now fixed it.

If you really want to test some workload on 2.6.28 to see if it too
works better with your fix, I won't stop you - but I'd much prefer
you to be applying your mind to 2.6.35 and 2.6.36!

Hugh
