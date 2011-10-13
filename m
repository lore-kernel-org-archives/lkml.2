Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab1JMUtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:49:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62650 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab1JMUtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:49:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=Qh0rs0cEOIIO/mwV7nw5I/eIloCxiM6B+QUkFY6n4BUw8K+8bw47oStcdvaUWfDbT
	xqUx1KZ7hAAxy2k2W9q7w==
Date: Thu, 13 Oct 2011 13:49:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>
cc: ian.campbell@citrix.com, linux-kernel@vger.kernel.org, hch@infradead.org,
        jaxboe@fusionio.com, linux-mm@kvack.org
Subject: Re: [PATCH] mm: add a "struct page_frag" type containing a page,
 offset and length
In-Reply-To: <20111013.163708.1319779926961023813.davem@davemloft.net>
Message-ID: <alpine.DEB.2.00.1110131348310.24853@chino.kir.corp.google.com>
References: <1318500176-10728-1-git-send-email-ian.campbell@citrix.com> <alpine.DEB.2.00.1110131327470.24853@chino.kir.corp.google.com> <20111013.163708.1319779926961023813.davem@davemloft.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, David Miller wrote:

> >> A few network drivers currently use skb_frag_struct for this purpose but I have
> >> patches which add additional fields and semantics there which these other uses
> >> do not want.
> >> 
> > 
> > Is this patch a part of a larger series that actually uses 
> > struct page_frag?  Probably a good idea to post them so we know it doesn't 
> > just lie there dormant.
> 
> See:
> 
> http://patchwork.ozlabs.org/patch/118693/
> http://patchwork.ozlabs.org/patch/118694/
> http://patchwork.ozlabs.org/patch/118695/
> http://patchwork.ozlabs.org/patch/118700/
> http://patchwork.ozlabs.org/patch/118696/
> http://patchwork.ozlabs.org/patch/118699/
> 
> This is a replacement for patch #1 in that series.
> 

Ok, let's add Andrew to the thread so this can go through -mm in 
preparation for that series.
