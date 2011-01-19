Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab1ASQom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:44:42 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48090 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839Ab1ASQok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:44:40 -0500
Date: Wed, 19 Jan 2011 22:14:33 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [PATCH 00/14] PV ticket locks without expanding spinlock
Message-ID: <20110119164432.GA30669@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 01:08:31PM -0800, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Hi all,
> 
> This is a revised version of the pvticket lock series.

The 3-patch series to follow this email extends KVM-hypervisor and Linux guest 
running on KVM-hypervisor to support pv-ticket spinlocks.

Two hypercalls are being introduced in KVM hypervisor, one that allows a
vcpu (spinning on a lock) to block and another that allows a vcpu to kick
another out of blocking state.

Patches are against 2.6.37 mainline kernel. I also don't yet have numbers 
at this time to show benefit of pv-ticketlocks - I would think the benefit
should be similar across hypervisors (Xen and KVM in this case).

- vatsa
