Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab2CELMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 06:12:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55696 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab2CELL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 06:11:57 -0500
Message-ID: <1330945883.11248.239.camel@twins>
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        linux-kernel@vger.kernel.org, ravitillo@lbl.gov,
        khandual@linux.vnet.ibm.com, asharma@fb.com, robert.richter@amd.com,
        ming.m.lin@intel.com, vweaver1@eecs.utk.edu, andi@firstfloor.org
Date: Mon, 05 Mar 2012 12:11:23 +0100
In-Reply-To: <20120305104933.GD18556@elte.hu>
References: <20120224094048.GA7952@quad> <4F47ABAD.9080408@gmail.com>
	 <CABPqkBT1R_SJiQkjujS4dN5yQZPakjOmmCLNR3DmNxTmVT_p9A@mail.gmail.com>
	 <4F47AD6A.6080609@gmail.com>
	 <CABPqkBQyBtxO3ytcZKHyGNAiwYzmqODy+C-EY5gQTENKtngBFw@mail.gmail.com>
	 <4F47B1A3.6050503@gmail.com>
	 <CABPqkBT=po0=-oi0GgGEVCNCxuSMwMyh5vPz=sWcNrqSZDc68Q@mail.gmail.com>
	 <CABPqkBTBkrA5qdeyhznr48Pqa9L-EX-LABypX55f_GoMRk-hDg@mail.gmail.com>
	 <20120302190822.GA12431@infradead.org>
	 <20120303194346.GB22044@infradead.org> <20120305104933.GD18556@elte.hu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 11:49 +0100, Ingo Molnar wrote:
> * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> 
> > Em Fri, Mar 02, 2012 at 04:08:22PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > Em Fri, Mar 02, 2012 at 06:47:38PM +0100, Stephane Eranian escreveu:
> > > > Arnaldo,
> > > > 
> > > > What do you think about this patch?
> > > 
> > > I'm processing perf/core patches today, will get to this one and merge
> > > or let you know objections,
> > 
> > Ingo,
> > 
> > 	What is the status of merging
> > http://git.kernel.org/?p=linux/kernel/git/peterz/queue.git;a=summary ?
> > 
> > 	After that I can try merging Stephane's autho-detect patch,
> 
> I guess I'll get this from Peter soonish?
> 
> I think it would be nice to have the tooling patches in the same 
> queue as well, so that I can try it all out as one package 
> before pushing it.

Hmm,. I somehow thought you already had it since you complained about
that record vs report thing. Lemme resurrect that series then.. :/
