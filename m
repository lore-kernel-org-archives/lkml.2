Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab1EYVYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:24:25 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:49138 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab1EYVYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:24:24 -0400
Date: Wed, 25 May 2011 17:24:00 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        fbuihuu@gmail.com, paulus@samba.org, acme@redhat.com
Subject: Re: perf: regression with PERF_EVENT_IOC_REFRESH
In-Reply-To: <20110525103921.GB30983@elte.hu>
Message-ID: <alpine.DEB.2.00.1105251722550.25021@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu> <1306182141.2497.5.camel@laptop> <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu> <1306233036.2497.15.camel@laptop> <alpine.DEB.2.00.1105241041490.10575@cl320.eecs.utk.edu>
 <1306249830.18455.41.camel@twins> <20110524154020.GA26516@elte.hu> <alpine.DEB.2.00.1105241616280.24062@cl320.eecs.utk.edu> <20110525103921.GB30983@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Ingo Molnar wrote:
> * Vince Weaver <vweaver1@eecs.utk.edu> wrote:
> 
> Well, i gave you a suggestion of how to prevent such regressions in 
> the future, should you be worried about such regressions.
> 
>  - or help us build better tests, either to 'perf test' (or to LTP)

I do have a perf_event validation test suite that I maintain to help when 
debugging PAPI issues.

   http://web.eecs.utk.edu/~vweaver1/projects/perf-events/validation.html

it's only about 12 tests right now, but feel free to use them if you'd 
like (they're GPL).  I really don't have any interest in merging them into 
the perf tree though.

Vince
