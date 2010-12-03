Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308Ab0LCOKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:10:42 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:33245 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab0LCOKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:10:41 -0500
Date: Fri, 3 Dec 2010 19:40:37 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
Message-ID: <20101203141037.GE16411@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20101202144129.4357fe00@annuminas.surriel.com>
 <20101202144423.3ad1908d@annuminas.surriel.com>
 <1291382619.32004.2124.camel@laptop>
 <20101203133056.GF27994@linux.vnet.ibm.com>
 <1291385010.32004.2165.camel@laptop>
 <20101203140607.GA9800@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203140607.GA9800@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 07:36:07PM +0530, Srivatsa Vaddagiri wrote:
> On Fri, Dec 03, 2010 at 03:03:30PM +0100, Peter Zijlstra wrote:
> > No, because they do receive service (they spend some time spinning
> > before being interrupted), so the respective vruntimes will increase, at
> > some point they'll pass B0 and it'll get scheduled.
> 
> Is that sufficient to ensure that B0 receives its fair share (1/3 cpu in this
> case)?

Hmm perhaps yes, althought at cost of tons of context switches, which would be
nice to minimize on?

- vatsa
