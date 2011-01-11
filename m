Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab1AKWBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 17:01:54 -0500
Received: from smtp-out.google.com ([216.239.44.51]:21266 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1AKWBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 17:01:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=POYFqL11a0GGgIPKLljZTGXF87+eBNCEGvLAVGI0nZM+wbp97SfvJ3llExiQL8+iB9
         uO1NXOY3pJ9ORUCk13uw==
Date: Tue, 11 Jan 2011 14:01:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, hughd@google.com, mel@csn.ul.ie
Subject: Re: + mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix.patch
 added to -mm tree
In-Reply-To: <20110111135547.ce6c273c.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1101111401150.17283@chino.kir.corp.google.com>
References: <201101112046.p0BKk2Js005902@imap1.linux-foundation.org> <alpine.DEB.2.00.1101111341590.7551@chino.kir.corp.google.com> <20110111135547.ce6c273c.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011, Andrew Morton wrote:

> Subject: mm/page_alloc.c: don't cache `current' in a local
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> It's old-fashioned and unneeded.
> 
> akpm:/usr/src/25> size mm/page_alloc.o
>    text    data     bss     dec     hex filename
>   39884 1241317   18808 1300009  13d629 mm/page_alloc.o (before)
>   39838 1241317   18808 1299963  13d5fb mm/page_alloc.o (after)
> 
> Cc: David Rientjes <rientjes@google.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Hugh Dickins <hughd@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: David Rientjes <rientjes@google.com>

Thanks!
