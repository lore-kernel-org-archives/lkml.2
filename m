Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab2CEKtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:49:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49627 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472Ab2CEKtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:49:51 -0500
Date: Mon, 5 Mar 2012 11:49:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        linux-kernel@vger.kernel.org, peterz@infradead.org, ravitillo@lbl.gov,
        khandual@linux.vnet.ibm.com, asharma@fb.com, robert.richter@amd.com,
        ming.m.lin@intel.com, vweaver1@eecs.utk.edu, andi@firstfloor.org
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
Message-ID: <20120305104933.GD18556@elte.hu>
References: <20120224094048.GA7952@quad>
 <4F47ABAD.9080408@gmail.com>
 <CABPqkBT1R_SJiQkjujS4dN5yQZPakjOmmCLNR3DmNxTmVT_p9A@mail.gmail.com>
 <4F47AD6A.6080609@gmail.com>
 <CABPqkBQyBtxO3ytcZKHyGNAiwYzmqODy+C-EY5gQTENKtngBFw@mail.gmail.com>
 <4F47B1A3.6050503@gmail.com>
 <CABPqkBT=po0=-oi0GgGEVCNCxuSMwMyh5vPz=sWcNrqSZDc68Q@mail.gmail.com>
 <CABPqkBTBkrA5qdeyhznr48Pqa9L-EX-LABypX55f_GoMRk-hDg@mail.gmail.com>
 <20120302190822.GA12431@infradead.org>
 <20120303194346.GB22044@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120303194346.GB22044@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Fri, Mar 02, 2012 at 04:08:22PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Fri, Mar 02, 2012 at 06:47:38PM +0100, Stephane Eranian escreveu:
> > > Arnaldo,
> > > 
> > > What do you think about this patch?
> > 
> > I'm processing perf/core patches today, will get to this one and merge
> > or let you know objections,
> 
> Ingo,
> 
> 	What is the status of merging
> http://git.kernel.org/?p=linux/kernel/git/peterz/queue.git;a=summary ?
> 
> 	After that I can try merging Stephane's autho-detect patch,

I guess I'll get this from Peter soonish?

I think it would be nice to have the tooling patches in the same 
queue as well, so that I can try it all out as one package 
before pushing it.

Thanks,

	Ingo
