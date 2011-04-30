Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761200Ab1D3BxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 21:53:20 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:36742 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761138Ab1D3BxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 21:53:19 -0400
Date: Fri, 29 Apr 2011 21:53:04 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: re-enable Nehalem raw Offcore-Events support
In-Reply-To: <20110429164227.GA25491@elte.hu>
Message-ID: <alpine.DEB.2.00.1104292149480.9459@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu> <20110429164227.GA25491@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011, Ingo Molnar wrote:

> Generalization of offcore, NUMA memory events is very much possible and 
> desirable, and Peter has posted an RFC patch that implements one form of it:
> 
>    https://lkml.org/lkml/2011/4/22/281
> 

OK, so I "reviewed" this patch. 

It creates a "generalized" new event, that is only actually available on 
Nehalem and Westmere.  It's listed as unavailable for all other known 
architectures.

How is this any better than just using the event by its actual name if you 
happen to have a Nehalem-esque chip?

This is just pointless kernel bloat.

So here's my review:
 NACK

Vince
