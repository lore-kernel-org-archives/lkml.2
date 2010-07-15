Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934685Ab0GOUUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 16:20:47 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:53975 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934651Ab0GOUUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 16:20:46 -0400
Date: Thu, 15 Jul 2010 15:17:23 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q2 00/19] SLUB with queueing (V2) beats SLAB netperf TCP_RR
In-Reply-To: <alpine.DEB.2.00.1007141518030.17291@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1007151515230.21299@router.home>
References: <20100709190706.938177313@quilx.com> <alpine.DEB.2.00.1007141518030.17291@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010, David Rientjes wrote:

> There are a couple differences between how you're using it compared to how
> I showed the initial regression between slab and slub, however: you're
> using localhost for your netserver which isn't representative of a real
> networking round-robin workload and you're using a smaller system with
> eight cores.  We never measured a _significant_ performance problem with
> slub compared to slab with four or eight cores, the problem only emerges
> on larger systems.

Larger systems would more NUMA support than is present in the current
patches.

> When running this patchset on two (client and server running
> netperf-2.4.5) four 2.2GHz quad-core AMD processors with 64GB of memory,
> here's the results:

What is their NUMA topology? I dont have anything beyond two nodes here.

