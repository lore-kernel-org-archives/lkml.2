Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab2CGFnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:43:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64131 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab2CGFnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:43:00 -0500
Date: Tue, 6 Mar 2012 21:42:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cong Wang <xiyou.wangcong@gmail.com>
cc: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH -v2] mm: SLAB Out-of-memory diagnostics
In-Reply-To: <4F56ECE6.4010100@gmail.com>
Message-ID: <alpine.DEB.2.00.1203062142290.6424@chino.kir.corp.google.com>
References: <20120305181041.GA9829@x61.redhat.com> <4F56ECE6.4010100@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, Cong Wang wrote:

> > Following the example at mm/slub.c, add out-of-memory diagnostics to the
> > SLAB allocator to help on debugging certain OOM conditions.
> > 
> > An example print out looks like this:
> > 
> >    <snip page allocator out-of-memory message>
> >    SLAB: Unable to allocate memory on node 0 (gfp=0x11200)
> >       cache: bio-0, object size: 192, order: 0
> >       node0: slabs: 3/3, objs: 60/60, free: 0
> > 
> 
> Nitpick:
> 
> What about "node: 0" instead of "node0: " ?
> 

Good catch, that format would match the output of the slub out-of-memory 
messages.
