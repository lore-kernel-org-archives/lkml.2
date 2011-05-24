Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab1EXRxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:53:47 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:36623 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918Ab1EXRxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:53:36 -0400
Date: Tue, 24 May 2011 13:53:25 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, fbuihuu@gmail.com, mingo@elte.hu,
        paulus@samba.org, acme@redhat.com
Subject: Re: perf: regression with PERF_EVENT_IOC_REFRESH
In-Reply-To: <1306249830.18455.41.camel@twins>
Message-ID: <alpine.DEB.2.00.1105241350020.24062@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>  <1306182141.2497.5.camel@laptop>  <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>  <1306233036.2497.15.camel@laptop>  <alpine.DEB.2.00.1105241041490.10575@cl320.eecs.utk.edu>
 <1306249830.18455.41.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, Peter Zijlstra wrote:

> On Tue, 2011-05-24 at 11:04 -0400, Vince Weaver wrote:
> > 2.6.37, 2.6.38, or 2.6.39 then it would be silly to do it just for
> > 2.6.40.
> 
> Oh, I assumed it was recent and .39/.40 would suffice.

It turns out the problem was only introduced in PAPI in November ( I had 
assumed it dated back further).  So maybe not as dire as it seemed at 
first.  

The fix to PAPI does seem to be trivial, though the whole set of 
bad code was introduced to work around a different problem so I need
to verify the fix doesn't break other things.

Thanks,

Vince
vweaver1@eecs.utk.edu
