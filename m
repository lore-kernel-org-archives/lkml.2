Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab0LRSN4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 13:13:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757141Ab0LRSNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 13:13:55 -0500
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <mgalbraith@suse.de>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4D0CEA7F.9080603@redhat.com>
References: <20101213224434.7495edb2@annuminas.surriel.com>
	 <20101213224657.7e141746@annuminas.surriel.com>
	 <1292306896.7448.157.camel@marge.simson.net> <4D0A6D34.6070806@redhat.com>
	 <1292569018.7772.75.camel@marge.simson.net>
	 <1292570143.7772.84.camel@marge.simson.net>  <4D0CEA7F.9080603@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Dec 2010 20:13:49 +0100
Message-ID: <1292699629.1181.58.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-12-18 at 19:08 +0200, Avi Kivity wrote:
> On 12/17/2010 09:15 AM, Mike Galbraith wrote:
> > BTW, with this vruntime donation thingy, what prevents a task from
> > forking off accomplices who do nothing but wait for a wakeup and
> > yield_to(exploit)?
> >
> 
> What's the difference between that and forking off accomplices who 
> run(exploit) directly?

The clock still advances.  What I described is a clock stopper.

> Many threads dominating the scheduler has been solved by group 
> scheduling.  We need to make sure directed yield doesn't violate that, 
> but I don't see new problems.

Let it become possible to stop clocks, and you surely will :)

	-Mike


