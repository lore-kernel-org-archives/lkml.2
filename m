Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab1EYKjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 06:39:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37458 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab1EYKj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 06:39:29 -0400
Date: Wed, 25 May 2011 12:39:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        fbuihuu@gmail.com, paulus@samba.org, acme@redhat.com
Subject: Re: perf: regression with PERF_EVENT_IOC_REFRESH
Message-ID: <20110525103921.GB30983@elte.hu>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>
 <1306182141.2497.5.camel@laptop>
 <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>
 <1306233036.2497.15.camel@laptop>
 <alpine.DEB.2.00.1105241041490.10575@cl320.eecs.utk.edu>
 <1306249830.18455.41.camel@twins>
 <20110524154020.GA26516@elte.hu>
 <alpine.DEB.2.00.1105241616280.24062@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105241616280.24062@cl320.eecs.utk.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vweaver1@eecs.utk.edu> wrote:

> > suggest moving these usecases into 'perf test' or so - that it 
> > gets run every day:
> 
> you can feel free to install PAPI on your test machines and give it 
> a run daily too.  It's open source

Well, i gave you a suggestion of how to prevent such regressions in 
the future, should you be worried about such regressions.

The standing upstream policy is that while we try to do a good effort 
and obviously fix everything we find ourselves or which gets reported 
to us, we cannot test everything so if you want us to fix bugs you 
need to pick one or more of these options:

 - run our code

 - or help us build better tests, either to 'perf test' (or to LTP)

 - or get your users to test recent upstream kernels for you

 - or ignore us and deal with regressions whenever you get hit by them

Your choice really.

Thanks,

	Ingo
