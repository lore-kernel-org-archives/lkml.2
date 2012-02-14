Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab2BNQMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:12:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:55148 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2BNQMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:12:03 -0500
Date: Tue, 14 Feb 2012 14:11:16 -0200
From: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Arun Sharma <asharma@fb.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Roberto Agostino Vitillo <ravitillo@lbl.gov>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vweaver1@eecs.utk.edu>
Subject: Re: [GIT PULL 00/16] perf/core improvements and fixes
Message-ID: <20120214161116.GF28614@infradead.org>
References: <1329184375-27911-1-git-send-email-acme@infradead.org>
 <4F39CBE0.6050806@gmail.com>
 <4F39D00D.2060206@gmail.com>
 <4F39ECDB.5090609@lge.com>
 <4F39EFBB.2010301@gmail.com>
 <20120214105018.GV22598@amd.com>
 <20120214131046.GA28614@infradead.org>
 <20120214143853.GC28614@infradead.org>
 <20120214151039.GA2238@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214151039.GA2238@amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 14, 2012 at 04:10:39PM +0100, Joerg Roedel escreveu:
> On Tue, Feb 14, 2012 at 12:38:53PM -0200, Arnaldo Carvalho de Melo wrote:
> >  	bool		   sample_id_all_avail;
> > +	bool		   exclude_guest_missing;
> >  	bool		   dump_symtab;
> >  	const char	   *cpu_list;
> >  	struct hist_entry  *sym_filter_entry;
> 
> I was about to prepare a similar patch :) But anyway, this one works
> too.
> 
> Tested-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> (on 2.6.32)

thanks, I'm commiting it now after testing it on a 3.0-rt kernel,

- Arnaldo
