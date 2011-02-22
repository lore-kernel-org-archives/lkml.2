Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1BVVWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:22:08 -0500
Received: from smtp-out.google.com ([216.239.44.51]:15193 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab1BVVWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:22:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=rliBhuopMtp1gLzwVIeblytVgxY6ZCvE91JoNsslZGc4PqDJHn/cNxtXbztHq1Obo9
         U5zdiDoaPNvc6GzCJf6g==
Date: Tue, 22 Feb 2011 13:21:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 3/5] pass pte size argument in to smaps_pte_entry()
In-Reply-To: <20110222015342.5DD9FC72@kernel>
Message-ID: <alpine.DEB.2.00.1102221320010.5929@chino.kir.corp.google.com>
References: <20110222015338.309727CA@kernel> <20110222015342.5DD9FC72@kernel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Dave Hansen wrote:

> 
> This patch adds an argument to the new smaps_pte_entry()
> function to let it account in things other than PAGE_SIZE
> units.  I changed all of the PAGE_SIZE sites, even though
> not all of them can be reached for transparent huge pages,
> just so this will continue to work without changes as THPs
> are improved.
> 
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>
