Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab1BVVWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:22:04 -0500
Received: from smtp-out.google.com ([74.125.121.67]:33938 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab1BVVWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:22:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=JMkO4eW2kp5mv9Id/dph0osI9cuOITMvmqdYLcRmiTjKe9VaUZbhKsXJJT17eYQCws
         WHOcsoPqobcVhPi+9k/w==
Date: Tue, 22 Feb 2011 13:21:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/5] break out smaps_pte_entry() from smaps_pte_range()
In-Reply-To: <20110222015340.B0D1C3FC@kernel>
Message-ID: <alpine.DEB.2.00.1102221318300.5929@chino.kir.corp.google.com>
References: <20110222015338.309727CA@kernel> <20110222015340.B0D1C3FC@kernel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Dave Hansen wrote:

> 
> We will use smaps_pte_entry() in a moment to handle both small
> and transparent large pages.  But, we must break it out of
> smaps_pte_range() first.
> 
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>
