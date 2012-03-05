Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab2CEUEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:04:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757455Ab2CEUEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:04:08 -0500
Message-ID: <4F551BE6.4050509@redhat.com>
Date: Mon, 05 Mar 2012 15:02:46 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Josef Bacik <josef@redhat.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH -v2] mm: SLAB Out-of-memory diagnostics
References: <20120305181041.GA9829@x61.redhat.com>
In-Reply-To: <20120305181041.GA9829@x61.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 01:10 PM, Rafael Aquini wrote:
> Following the example at mm/slub.c, add out-of-memory diagnostics to the
> SLAB allocator to help on debugging certain OOM conditions.
>
> An example print out looks like this:
>
>    <snip page allocator out-of-memory message>
>    SLAB: Unable to allocate memory on node 0 (gfp=0x11200)
>       cache: bio-0, object size: 192, order: 0
>       node0: slabs: 3/3, objs: 60/60, free: 0
>
> Signed-off-by: Rafael Aquini<aquini@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

