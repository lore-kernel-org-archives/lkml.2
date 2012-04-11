Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979Ab2DKBtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 21:49:07 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:48823 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968Ab2DKBtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 21:49:05 -0400
Date: Wed, 11 Apr 2012 03:48:55 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] remove swap token code
Message-ID: <20120411014855.GA1929@cmpxchg.org>
References: <20120409113201.6dff571a@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120409113201.6dff571a@annuminas.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 11:32:01AM -0400, Rik van Riel wrote:
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

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
