Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab0INVAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 17:00:23 -0400
Received: from freeflow.nu ([178.79.134.28]:52366 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab0INVAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 17:00:22 -0400
Message-ID: <4C8FE263.5070101@kernel.org>
Date: Wed, 15 Sep 2010 00:00:19 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
References: <1284490101-2362-1-git-send-email-penberg@kernel.org> <1284490101-2362-2-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1009141243290.1470@chino.kir.corp.google.com> <AANLkTinj2P_QbdgdLS3BweSMDzhQH5g4p2B3SqS=CNYc@mail.gmail.com> <alpine.DEB.2.00.1009141320090.7123@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1009141320090.7123@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 14.9.2010 23.56, David Rientjes wrote:
>> In my not-so-humble opinion, either the merging needs to go away
>> entirely, or the misleading output needs to be fixed.
> Cache merging may have been advertised as a bigger performance improvement
> than it actually is, and I don't do it in my own slab allocator for other
> reasons, but it does lead to more effective memory use by reducing slab
> fragmentation.  On one of my benchmarking servers, over 60% of caches are
> merged and /sys/kernel/slab/.../partial reports roughly the same percent
> of fewer total partial slabs over the system in comparison to
> slub_nomerge.
Last time I checked (and it's been a while), it did reduce _internal 
fragmentation_ for the naive "memory used after boot" scenario. I don't 
think I ever advertised it as a performance improvement. Dunno if 
somebody else did.

             Pekka
