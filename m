Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab2DLPHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 11:07:41 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:45173 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407Ab2DLPHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:07:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=meloft.net; h=date:from:to:cc
	:subject:message-id:references:mime-version:content-type:
	in-reply-to; q=dns; s=meloft.net; b=vSRuYQ2PtULtjpE3A4McvwH/Uz38
	R59Iv68e/NvJkSkwlNiG6g159mGx09gPkI2pmwJjh5mbHNk0JuI3iGmTZJx/yXcI
	KVysbR8NKadym5GDaBalkL9LtQa7EGMcfBEsX+qn5DKqWfTWcvE2D2M8L1vUYqo1
	sk8/Ep+vGAHdFLo=
Date: Thu, 12 Apr 2012 11:06:12 -0400
From: Bob Picco <bpicco@meloft.net>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH -mm] remove swap token code
Message-ID: <20120412150612.GA12549@gw1>
References: <20120409113201.6dff571a@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120409113201.6dff571a@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:	[Mon Apr 09 2012, 11:32:01AM EDT]
> The swap token code no longer fits in with the current VM model.
> It does not play well with cgroups or the better NUMA placement
> code in development, since we have only one swap token globally.
> 
> It also has the potential to mess with scalability of the system,
> by increasing the number of non-reclaimable pages on the active
> and inactive anon LRU lists.
> 
> Last but not least, the swap token code has been broken for a
> year without complaints.  This suggests we no longer have much
> use for it.
> 
> The days of sub-1G memory systems with heavy use of swap are
> over. If we ever need thrashing reducing code in the future,
> we will have to implement something that does scale.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>

Acked-by: Bob Picco <bpicco@meloft.net>

