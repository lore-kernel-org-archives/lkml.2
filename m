Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab2EYOrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 10:47:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52970 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab2EYOrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 10:47:15 -0400
Date: Fri, 25 May 2012 11:47:10 -0300
From: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf record: Fixing record option data type in
 parse_branch_stack
Message-ID: <20120525144710.GG2336@infradead.org>
References: <4FBDFDA6.5010304@linux.vnet.ibm.com>
 <4FBF185F.4060007@linux.vnet.ibm.com>
 <4FBF3CD1.7030603@linux.vnet.ibm.com>
 <CABPqkBS6cdUkKgC1Jp_pzMWxDKZYJtomoZUx6g2z739y=TkPAw@mail.gmail.com>
 <4FBF5FAF.4010906@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBF5FAF.4010906@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 25, 2012 at 04:02:15PM +0530, Anshuman Khandual escreveu:
> On Friday 25 May 2012 02:14 PM, Stephane Eranian wrote:
> 
> > Hi,
> > 
> > It should be something like that instead:
> > 
> > diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> > index 8a9687e..c9ca7c4 100644
> > --- a/tools/perf/perf.h
> > +++ b/tools/perf/perf.h
> > @@ -228,7 +228,7 @@ struct perf_record_opts {
> >         unsigned int freq;
> >         unsigned int mmap_pages;
> >         unsigned int user_freq;
> > -       int          branch_stack;
> > +       u64          branch_stack;
> >         u64          default_interval;
> >         u64          user_interval;
> >  };
> > 
> 
> 
> 
> Agreed. I just tried to fix the problem where it was more evident because
> of the data type mismatch.

Can you send an updated patch on a message just for that?

- Arnaldo
