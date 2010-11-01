Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab0KASIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:08:13 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19474 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab0KASIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:08:12 -0400
Date: Mon, 1 Nov 2010 18:57:39 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH] Perf, AMD: Prefer kzalloc() over kmalloc()+memset() in
 amd_alloc_nb()
In-Reply-To: <1288634113.2039.20.camel@laptop>
Message-ID: <alpine.LNX.2.00.1011011857220.9616@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010302101240.1572@swampdragon.chaosbits.net> <1288634113.2039.20.camel@laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010, Peter Zijlstra wrote:

> On Sat, 2010-10-30 at 21:06 +0200, Jesper Juhl wrote:
> > Hi,
> > 
> > I believe this would be an improvement?
> > 
> > Prefer kzalloc() over kmalloc()+memset() in amd_alloc_nb().
> > 
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> 
> 
> I've changed it to..
> 
> ---
> Subject: perf, amd: Use kmalloc_node(,__GFP_ZERO) for northbridge structure allocation
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Nov 01 18:52:05 CET 2010
> 
> Jasper suggested we use the zeroing capability of the allocators
> instead of calling memset ourselves. Add node affinity while we're at
> it.
> 
> Reported-by: Jesper Juhl <jj@chaosbits.net>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Fine by me.

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

