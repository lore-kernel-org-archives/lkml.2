Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab0HDEjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:39:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21473 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab0HDEjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:39:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=UjsN1q2wkoE7rHkaAtPKTcEjfpAN94zvMSMrLf9/kuoyVnglWXO7l3tCb3FA9bZFZ
	KgenC/VrxasZmX//EYxCA==
Date: Tue, 3 Aug 2010 21:39:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q3 00/23] SLUB: The Unified slab allocator (V3)
In-Reply-To: <20100804024514.139976032@linux.com>
Message-ID: <alpine.DEB.2.00.1008032138160.20049@chino.kir.corp.google.com>
References: <20100804024514.139976032@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010, Christoph Lameter wrote:

> The following is a first release of an allocator based on SLAB
> and SLUB that integrates the best approaches from both allocators. The
> per cpu queuing is like the two prior releases. The NUMA facilities
> were much improved vs V2. Shared and alien cache support was added to
> track the cache hot state of objects. 
> 

This insta-reboots on my netperf benchmarking servers (but works with 
numa=off), so I'll have to wait until I can hook up a serial before 
benchmarking this series.
