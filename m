Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab1ELNnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:43:42 -0400
Received: from 8bytes.org ([88.198.83.132]:51262 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046Ab1ELNnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:43:41 -0400
Date: Thu, 12 May 2011 15:43:40 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 0/5] KVM in-guest performance monitoring
Message-ID: <20110512134339.GH8707@8bytes.org>
References: <1305129333-7456-1-git-send-email-avi@redhat.com> <20110512093309.GD8707@8bytes.org> <4DCBACC7.8080000@siemens.com> <20110512131130.GG8707@8bytes.org> <4DCBDF5B.6000101@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCBDF5B.6000101@siemens.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 03:23:39PM +0200, Jan Kiszka wrote:
> On 2011-05-12 15:11, Joerg Roedel wrote:

> > Seriously, I think such decisions should be technical only and not
> > political like that. The losers of such political decisions are always
> > the users because they don't get useful features that are technical
> > possible.
> 
> Paravirt remains a workaround, useful until hardware provides a solution
> for all guests, and that often in an even more efficient way (like for
> MMU virtualization).

Fully agreed. And todays x86 CPUs lack proper support for virtualizing
the PMU. That will hopefully change but users want the feature today.

> We do not need to block a PV-PMU for Linux guests (or other OSes that
> want to adopt to it), but that will not be a solution for the problem,
> that's my point. A PV-PMU may even be useful to demonstrate usefulness
> of a virtual PMU the CPU vendors (if they aren't aware of this yet).

Right, if users actually use the virtual PMU this probably increases the
priority for proper hardware support.

	Joerg

