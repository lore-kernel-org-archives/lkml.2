Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934710Ab0GOUbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 16:31:13 -0400
Received: from smtp-out.google.com ([74.125.121.35]:43386 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934681Ab0GOUbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 16:31:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=idMoopHVxPJsN63V2AXHydvsHfrmY0Or5UP5QXwhq9S6sKGLRjqxtSqx3XpCLojUL
	l1cr6cb3cCFAKJi3coO5Q==
Date: Thu, 15 Jul 2010 13:30:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q2 00/19] SLUB with queueing (V2) beats SLAB netperf TCP_RR
In-Reply-To: <alpine.DEB.2.00.1007151515230.21299@router.home>
Message-ID: <alpine.DEB.2.00.1007151329000.9903@chino.kir.corp.google.com>
References: <20100709190706.938177313@quilx.com> <alpine.DEB.2.00.1007141518030.17291@chino.kir.corp.google.com> <alpine.DEB.2.00.1007151515230.21299@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010, Christoph Lameter wrote:

> > When running this patchset on two (client and server running
> > netperf-2.4.5) four 2.2GHz quad-core AMD processors with 64GB of memory,
> > here's the results:
> 
> What is their NUMA topology? I dont have anything beyond two nodes here.
> 

These two machines happen to have four 16GB nodes with asymmetrical 
distances:

# cat /sys/devices/system/node/node*/distance
10 20 20 30
20 10 20 20
20 20 10 20
30 20 20 10
