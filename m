Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab1ADGma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 01:42:30 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:47996 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750886Ab1ADGm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 01:42:28 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+ZM/Vh2Q6ZGyy3qV3Wj8QUnuDLQebgmdNZFYMRpd
	9KOuBZUyPbul4k
Subject: Re: [RFC -v3 PATCH 0/3] directed yield for Pause Loop Exiting
From: Mike Galbraith <efault@gmx.de>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20110103162637.29f23c40@annuminas.surriel.com>
References: <20110103162637.29f23c40@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 07:42:15 +0100
Message-ID: <1294123335.11283.26.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple questions.

On Mon, 2011-01-03 at 16:26 -0500, Rik van Riel wrote:
> When running SMP virtual machines, it is possible for one VCPU to be
> spinning on a spinlock, while the VCPU that holds the spinlock is not
> currently running, because the host scheduler preempted it to run
> something else.

Do you have any numbers?

If I were to, say, run a 256 CPU VM on my quad, would this help me get
more hackbench or whatever oomph from my (256X80386/20:) box?

> Both Intel and AMD CPUs have a feature that detects when a virtual
> CPU is spinning on a lock and will trap to the host.

Does an Intel Q6600 have this trap gizmo (iow will this do anything at
all for my little box if I were to try it out).

	-Mike

