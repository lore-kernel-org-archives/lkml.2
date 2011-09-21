Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1IURTC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 13:19:02 -0400
Received: from smtp-out.google.com ([74.125.121.67]:35261 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab1IURTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 13:19:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=T3YubsYcyTaJ10XiTsQvG053WNz/Pb1KRgURRpssFI1+6MQtQ6glEH490yvkGT7Wu
	2KLl9Pnse3DZucO2xVGBQ==
Date: Wed, 21 Sep 2011 10:18:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kyungmin Park <kmpark@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: compaction: staticize compact_zone_order
In-Reply-To: <20110921085843.GA16233@july>
Message-ID: <alpine.DEB.2.00.1109211018070.19682@chino.kir.corp.google.com>
References: <20110921085843.GA16233@july>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Sep 2011, Kyungmin Park wrote:

> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> There's no user to use compact_zone_order. So staticize this function.
> 

s/no user/no user outside of file scope/

> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: David Rientjes <rientjes@google.com>
