Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030256Ab2CBTOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 14:14:32 -0500
Received: from 177.16.140.54.static.host.gvt.net.br ([177.16.140.54]:56642
	"EHLO sandy.ghostprotocols.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751634Ab2CBTOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 14:14:31 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2012 14:14:31 EST
Date: Fri, 2 Mar 2012 16:08:22 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, ravitillo@lbl.gov,
        khandual@linux.vnet.ibm.com, asharma@fb.com, robert.richter@amd.com,
        ming.m.lin@intel.com, vweaver1@eecs.utk.edu, andi@firstfloor.org
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
Message-ID: <20120302190822.GA12431@infradead.org>
References: <20120224094048.GA7952@quad>
 <4F47ABAD.9080408@gmail.com>
 <CABPqkBT1R_SJiQkjujS4dN5yQZPakjOmmCLNR3DmNxTmVT_p9A@mail.gmail.com>
 <4F47AD6A.6080609@gmail.com>
 <CABPqkBQyBtxO3ytcZKHyGNAiwYzmqODy+C-EY5gQTENKtngBFw@mail.gmail.com>
 <4F47B1A3.6050503@gmail.com>
 <CABPqkBT=po0=-oi0GgGEVCNCxuSMwMyh5vPz=sWcNrqSZDc68Q@mail.gmail.com>
 <CABPqkBTBkrA5qdeyhznr48Pqa9L-EX-LABypX55f_GoMRk-hDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTBkrA5qdeyhznr48Pqa9L-EX-LABypX55f_GoMRk-hDg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 02, 2012 at 06:47:38PM +0100, Stephane Eranian escreveu:
> Arnaldo,
> 
> What do you think about this patch?

I'm processing perf/core patches today, will get to this one and merge
or let you know objections,

- Arnaldo
 
> 
> On Fri, Feb 24, 2012 at 4:51 PM, Stephane Eranian <eranian@google.com> wrote:
> > On Fri, Feb 24, 2012 at 4:49 PM, David Ahern <dsahern@gmail.com> wrote:
> >> On 2/24/12 8:40 AM, Stephane Eranian wrote:
> >>>
> >>> No, I don't. Read the code carefully. The for loop sets all known feature
> >>> bits.
> >>> Then, the ones not necessary or unused are turned off individually.
> >>
> >>
> >> Ok, I see now. The __set_feat loop is earlier in builtin-record.c, not the
> >> util code.
> >>
> > Yeah. Arnaldo simplified the original code in builtin-record.c to have the loop
> > instead of individual set_feat().
> >
> >> David
