Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab2CGFG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:06:59 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:50529 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616Ab2CGFG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:06:58 -0500
Message-ID: <4F56ECE6.4010100@gmail.com>
Date: Wed, 07 Mar 2012 13:06:46 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Josef Bacik <josef@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH -v2] mm: SLAB Out-of-memory diagnostics
References: <20120305181041.GA9829@x61.redhat.com>
In-Reply-To: <20120305181041.GA9829@x61.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 02:10 AM, Rafael Aquini wrote:
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

Nitpick:

What about "node: 0" instead of "node0: " ?

Thanks.
