Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0DMXz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 19:55:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:9517 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab0DMXz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 19:55:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Y+Go4O9bos1l0EjjrzFDVW9KYVybs069LHwqqQZjebR432rEa38/UXLuLfKE8PMrs
	Ztt3IGdzOTY8s9bn/6lTg==
Date: Tue, 13 Apr 2010 16:55:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/6] change alloc function in alloc_slab_page
In-Reply-To: <u2o28c262361004131640zd034a692s4b46ee77c08e1ccd@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1004131654340.8116@chino.kir.corp.google.com>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com> <8b348d9cc1ea4960488b193b7e8378876918c0d4.1271171877.git.minchan.kim@gmail.com> <alpine.DEB.2.00.1004131437140.8617@chino.kir.corp.google.com>
 <u2o28c262361004131640zd034a692s4b46ee77c08e1ccd@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010, Minchan Kim wrote:

> This changlog is bad.
> I will change it with following as when I send v2.
> 
> "alloc_slab_page always checks nid == -1, so alloc_page_node can't be
> called with -1.
>  It means node's validity check in alloc_pages_node is unnecessary.
>  So we can use alloc_pages_exact_node instead of alloc_pages_node.
>  It could avoid comparison and branch as 6484eb3e2a81807722 tried."
> 

Each patch in this series seems to be independent and can be applied 
seperately, so it's probably not necessary to make them incremental.
