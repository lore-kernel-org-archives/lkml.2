Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab1KGPfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:35:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab1KGPfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:35:00 -0500
Date: Mon, 7 Nov 2011 17:34:39 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHv2 2/9] KVM: Expose a version 2 architectural PMU to a
 guests
Message-ID: <20111107153439.GG8670@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
 <1320323618-10375-3-git-send-email-gleb@redhat.com>
 <1320675725.18053.40.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320675725.18053.40.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 03:22:05PM +0100, Peter Zijlstra wrote:
> On Thu, 2011-11-03 at 14:33 +0200, Gleb Natapov wrote:
> > @@ -35,6 +35,7 @@ config KVM
> >         select KVM_MMIO
> >         select TASKSTATS
> >         select TASK_DELAY_ACCT
> > +       select PERF_EVENTS 
> 
> Do you really want to make that an unconditional part of KVM? I know we
> can't currently build x86 without perf due to that hw breakpoint
> trainwreck, but people were actually wanting to solve that.
> 
I am fine either way (the only thing is that I can't check that I can
build kvm without pmu right now). But I doubt that there will be many
KVM deployment without perf enabled and making it optional will increase
test matrix. KVM has pretty extensive list of selects already for that
reason. I let maintainers to decide on this.

--
			Gleb.
