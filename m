Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab2JDWW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:22:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab2JDWWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 18:22:55 -0400
Date: Fri, 5 Oct 2012 00:22:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Pekka Enberg <penberg@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] SLAB changes for v3.7-rc0
In-Reply-To: <alpine.LFD.2.02.1210042055190.2119@tux.localdomain>
Message-ID: <alpine.LRH.2.00.1210050021050.31999@twin.jikos.cz>
References: <alpine.LFD.2.02.1210042055190.2119@tux.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2012, Pekka Enberg wrote:

> Hi Linus,
> 
> Please pull the latest SLAB tree from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus
> 
> New and noteworthy:
> 
>   * More SLAB allocator unification patches from Christoph Lameter and
>     others.  This paves the way for slab memcg patches that hopefully
>     will land in v3.8.
> 
>   * SLAB tracing improvements from Ezequiel Garcia.
> 
>   * Kernel tainting upon SLAB corruption from Dave Jones.
> 
>   * Miscellanous SLAB allocator bug fixes and improvements from various
>     people.

Pekka,

what are your plans with 

	https://lkml.org/lkml/2012/10/3/285

please? It'd be nice to have it in Linus' tree reasonably soon, otherwise 
we'll be receiving false positive lockdep reports over and over again.

Thanks,

-- 
Jiri Kosina
SUSE Labs

