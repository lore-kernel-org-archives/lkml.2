Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab1ASS36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 13:29:58 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:49360 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab1ASS34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:29:56 -0500
Date: Wed, 19 Jan 2011 23:59:41 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        kvm@vger.kernel.org, suzuki@in.ibm.com
Subject: Re: [PATCH 2/3] kvm hypervisor : Add hypercalls to support
 pv-ticketlock
Message-ID: <20110119182940.GA7235@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <20110119164432.GA30669@linux.vnet.ibm.com>
 <20110119171239.GB726@linux.vnet.ibm.com>
 <1295457672.28776.144.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295457672.28776.144.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 06:21:12PM +0100, Peter Zijlstra wrote:
> I didn't really read the patch, and I totally forgot everything from
> when I looked at the Xen series, but does the Xen/KVM hypercall
> interface for this include the vcpu to await the kick from?

No not yet, for reasons you mention below.

> My guess is not, since the ticket locks used don't know who the owner
> is, which is of course, sad. There are FIFO spinlock implementations
> that can do this though.. although I think they all have a bigger memory
> footprint.
> 
> The reason for wanting this should be clear I guess, it allows PI.

Yeah - that would be good to experiment with.

- vatsa
