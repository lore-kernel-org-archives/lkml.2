Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab0GNXwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:52:31 -0400
Received: from smtp-out.google.com ([74.125.121.35]:46469 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab0GNXwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:52:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=PEKMrdet0UmvL3MSKgbc1P0nav33Snodt2u46p+YatEunHP0bORVIjJylt7ChJJQX
	FqksLWxATBOOqgGc7VIIw==
Date: Wed, 14 Jul 2010 16:52:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q2 00/19] SLUB with queueing (V2) beats SLAB netperf TCP_RR
In-Reply-To: <20100709190706.938177313@quilx.com>
Message-ID: <alpine.DEB.2.00.1007141650110.29110@chino.kir.corp.google.com>
References: <20100709190706.938177313@quilx.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010, Christoph Lameter wrote:

> The following patchset cleans some pieces up and then equips SLUB with
> per cpu queues that work similar to SLABs queues.

Pekka, I think patches 4-8 could be applied to your tree now, they're 
relatively unchanged from what's been posted before.  (I didn't ack patch 
9 because I think it makes slab_lock() -> slab_unlock() matching more 
difficult with little win, but I don't feel strongly about it.)

I'd also consider patch 7 for 2.6.35-rc6 (and -stable).
