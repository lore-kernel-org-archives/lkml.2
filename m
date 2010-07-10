Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab0GJT5H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 15:57:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59367 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab0GJT5E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 15:57:04 -0400
Date: Sat, 10 Jul 2010 21:56:21 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>
Subject: Re: [S+Q2 00/19] SLUB with queueing (V2) beats SLAB netperf TCP_RR
Message-ID: <20100710195621.GA13720@fancy-poultry.org>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
	Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>
References: <20100709190706.938177313@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100709190706.938177313@quilx.com>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100619 (GNU/Linux)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:PEMbIyXKPFOhwLDVcdFOIBa+QffgQZH9UPjlxdBnuoY
 R3MhtPmvnXqSbCHnMtPyqAd5uMY2SjfNObu6do5tHbrzkbtErr
 qN0u4BmP2UmcNTnVR1b3H2no2uMbPopbBfPhhjR4i2xakGmxSU
 aEYKT1+iIh+64DyZLj0xWqj+p41XNxYAWAW8kOciWkrCoo/7GX
 G35LGb58mIwMY9yxRUNKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.07.2010, Christoph Lameter wrote: 

> The following patchset cleans some pieces up and then equips SLUB with
> per cpu queues that work similar to SLABs queues. With that approach
> SLUB wins significantly in hackbench and improves also on tcp_rr.

The patchset applies cleanly, however compilation fails with

[....]
mm/slub.c: In function ‘alloc_kmem_cache_cpus’:
mm/slub.c:2093: error: negative width in bit-field ‘<anonymous>’
make[1]: *** [mm/slub.o] Error 1
make: *** [mm] Error 2
make: *** Waiting for unfinished jobs....
[....]

