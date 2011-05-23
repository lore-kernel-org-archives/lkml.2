Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab1EWQX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:23:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58520 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab1EWQXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:23:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=qG0qjqbdtJmCXu3Csg1Un7f5BFKWvy9M877VVMb3RqcVKr8bswMDmJUsEkGok2Ey8u
         oeo0NcPXqpwD9ijdSYOg==
Date: Mon, 23 May 2011 09:23:18 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Christoph Hellwig <hch@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Adding an ugliness in __read_cache_page()?
In-Reply-To: <20110523072705.GA3966@infradead.org>
Message-ID: <alpine.LSU.2.00.1105230919480.4182@sister.anvils>
References: <alpine.LSU.2.00.1105221518180.17400@sister.anvils> <20110523072705.GA3966@infradead.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011, Christoph Hellwig wrote:
> On Sun, May 22, 2011 at 03:25:31PM -0700, Hugh Dickins wrote:
> > I find both ways ugly, but no nice alternative: introducing a new method
> > when the known callers are already tied to tmpfs/ramfs seems over the top.
> 
> Calling into shmem directly is the less ugly variant.

Okay, that's good, thanks.

> Long term killing
> that tmpfs abuse would be even better, but I already lost that fight
> when it was initially added.

I'd better match your restraint and not fan the flames now -
I believe we're on opposite sides, or at least orthogonal on that.

Hugh
