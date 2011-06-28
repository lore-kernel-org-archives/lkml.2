Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266Ab1F1Rbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:31:46 -0400
Received: from jaguar.mail.utk.edu ([160.36.0.84]:47942 "EHLO
	jaguar.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123Ab1F1RbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:31:09 -0400
Date: Tue, 28 Jun 2011 13:30:57 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@gmail.com>
Subject: Re: perf: is PERF_COUNT_SW_CONTEXT_SWITCHES a kernel or user
 event?
In-Reply-To: <20110627185933.GA3726@somewhere>
Message-ID: <alpine.DEB.2.00.1106281326190.7766@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1106241658420.23095@cl320.eecs.utk.edu> <1309171403.6701.77.camel@twins> <20110627185933.GA3726@somewhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011, Frederic Weisbecker wrote:
> 
> If you consider the strict meaning of exclude_user/exclude_kernel, they exclude
> events that _happen_ in user/kernel space. And context switches happen in kernel
> space.

I can see that it's somewhat arbitrary how context switches are 
classified.

I just want some assurances that now that it's moved to being
a kernel event it stays that way.

As it is, people upgrading from 2.6.32 to 2.6.34 and using the "cs:u"
event will suddently start getting "0" results.  

Possibly perf_events should just ignore exclude_kernel/exclude_user on an 
event like this where there is no real distinction.

Vince
vweaver1@eecs.utk.edu
