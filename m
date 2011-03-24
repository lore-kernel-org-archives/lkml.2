Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934246Ab1CXUlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:41:01 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:52244 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933904Ab1CXUlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:41:00 -0400
Date: Thu, 24 Mar 2011 21:39:54 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Nicolas Palix <Nicolas.Palix@inria.fr>,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
In-Reply-To: <AANLkTikL=PpJFvx4sC9c22Yf8QUivy2ZwwPhd_iNX+W=@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1103242136490.8555@pc-004.diku.dk>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
 <20110317211548.646b04d2@tpl.lwn.net> <1300419170.16880.956.camel@gandalf.stny.rr.com>
 <AANLkTikZK278BR5o1fP_w2u5PUPbgub9QT4XxzSmEhL5@mail.gmail.com>
 <AANLkTi=2d8S_Pi8kuZMXAmNvHa_2KrOs6K+_FF6P7-pU@mail.gmail.com>
 <Pine.LNX.4.64.1103200852080.28495@ask.diku.dk>
 <AANLkTi=MMKvA-9pFiM1K_JSXjS71JLRCem8THnhu-0=N@mail.gmail.com>
 <Pine.LNX.4.64.1103201007430.28495@ask.diku.dk> <8762r8mt0h.fsf@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1103241705510.8624@pc-004.diku.dk>
 <AANLkTinnTnPrS=rPssO6HiV_7tkGchDpxq6SJprL70ub@mail.gmail.com>
 <AANLkTikL=PpJFvx4sC9c22Yf8QUivy2ZwwPhd_iNX+W=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So does it mean that you do not even have a stable grammar ? Do you at
> least offer any guarantee that a script made for version X will still
> work in version X+1 ?

The inability to put - on <+... ...+> was a bug.  So I don't know if 
fixing a bug would be considered a sign of an unstable grammar.  There was 
also one deliberate change in the grammar some rc's ago related to the use 
of commas in sequences (parameter lists etc).  But otherwise, the changes 
in the grammar have been additions, as people eg ask for new kinds of 
metavariables.

But Coccinelle is a research prototype under development, not a product.  
So I'm not sure it is appropriate to say that we guarantee anything.

julia
