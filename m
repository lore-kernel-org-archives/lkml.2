Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab2CCToS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 14:44:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab2CCToR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 14:44:17 -0500
Date: Sat, 3 Mar 2012 16:43:46 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        asharma@fb.com, robert.richter@amd.com, ming.m.lin@intel.com,
        vweaver1@eecs.utk.edu, andi@firstfloor.org
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
Message-ID: <20120303194346.GB22044@infradead.org>
References: <20120224094048.GA7952@quad>
 <4F47ABAD.9080408@gmail.com>
 <CABPqkBT1R_SJiQkjujS4dN5yQZPakjOmmCLNR3DmNxTmVT_p9A@mail.gmail.com>
 <4F47AD6A.6080609@gmail.com>
 <CABPqkBQyBtxO3ytcZKHyGNAiwYzmqODy+C-EY5gQTENKtngBFw@mail.gmail.com>
 <4F47B1A3.6050503@gmail.com>
 <CABPqkBT=po0=-oi0GgGEVCNCxuSMwMyh5vPz=sWcNrqSZDc68Q@mail.gmail.com>
 <CABPqkBTBkrA5qdeyhznr48Pqa9L-EX-LABypX55f_GoMRk-hDg@mail.gmail.com>
 <20120302190822.GA12431@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302190822.GA12431@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 02, 2012 at 04:08:22PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Fri, Mar 02, 2012 at 06:47:38PM +0100, Stephane Eranian escreveu:
> > Arnaldo,
> > 
> > What do you think about this patch?
> 
> I'm processing perf/core patches today, will get to this one and merge
> or let you know objections,

Ingo,

	What is the status of merging
http://git.kernel.org/?p=linux/kernel/git/peterz/queue.git;a=summary ?

	After that I can try merging Stephane's autho-detect patch,

- Arnaldo
 
> > On Fri, Feb 24, 2012 at 4:51 PM, Stephane Eranian <eranian@google.com> wrote:
> > > On Fri, Feb 24, 2012 at 4:49 PM, David Ahern <dsahern@gmail.com> wrote:
> > >> On 2/24/12 8:40 AM, Stephane Eranian wrote:
> > >>>
> > >>> No, I don't. Read the code carefully. The for loop sets all known feature
> > >>> bits.
> > >>> Then, the ones not necessary or unused are turned off individually.
> > >>
> > >>
> > >> Ok, I see now. The __set_feat loop is earlier in builtin-record.c, not the
> > >> util code.
> > >>
> > > Yeah. Arnaldo simplified the original code in builtin-record.c to have the loop
> > > instead of individual set_feat().
> > >
> > >> David
