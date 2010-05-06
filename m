Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab0EFJYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:24:17 -0400
Received: from smtp-out.google.com ([74.125.121.35]:59446 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab0EFJYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:24:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=tGQv9AQysHExu3nnMS0uU3vKI5ap25afSzLMq107Mo/O8H91/YRcmxT27ndiQcUo5
	oNde0KiSt4EnHLfY8j1cg==
Date: Thu, 6 May 2010 02:24:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: fix fake apicid to node mapping for numa
 emulation
In-Reply-To: <20100506070732.GA32002@elte.hu>
Message-ID: <alpine.DEB.2.00.1005060222560.19473@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1005041659400.13683@chino.kir.corp.google.com> <20100506070732.GA32002@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010, Ingo Molnar wrote:

> > apicids must be mapped to the lowest node ids to maintain generic kernel use 
> > of functions such as cpu_to_node() that determine device affinity.
> > 
> > Signed-off-by: David Rientjes <rientjes@google.com>
> > ---
> >  Third resend of the same patch.
> > 
> >  arch/x86/mm/srat_64.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> There's no info in the changelog about what negative effects this bug had when 
> it was found, on what hardware it occured, and what the general urgency of the 
> patch is.
> 

Ah, true.  Given the relative obscurity of using NUMA emulation to being 
with, it would probably benefit from being even more verbose as well.  
I'll rewrite the changelog and reply to this message with it.

Thanks.
