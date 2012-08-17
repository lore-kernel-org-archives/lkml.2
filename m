Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030670Ab2HQH1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:27:54 -0400
Received: from mail.x86-64.org ([217.9.48.20]:55165 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab2HQH1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:27:52 -0400
Date: Fri, 17 Aug 2012 09:27:44 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [RFC PATCH -v2 3/4] perf: Add persistent event facilities
Message-ID: <20120817072744.GB20591@aftab.osrc.amd.com>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
 <1345139123-15212-4-git-send-email-bp@amd64.org>
 <1345155155.3708.19.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345155155.3708.19.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 06:12:35PM -0400, Steven Rostedt wrote:
> On Thu, 2012-08-16 at 19:45 +0200, Borislav Petkov wrote:
> >  
> > -static void ring_buffer_put(struct ring_buffer *rb)
> > +void ring_buffer_put(struct ring_buffer *rb)
> >  {
> >  	struct perf_event *event, *n;
> >  	unsigned long flags;
> 
> I have to say that it is really unfortunate that we have two ring
> buffers in the kernel, called struct ring_buffer. One being global and
> one being local to events. And now we are exporting the name
> "ring_buffer_*" too! This is going to confuse the hell out of people.
> 
> Perhaps this should have been called perf_buffer, as that is what it's
> used for.

Right, I guess the easiest would be to rename it for now.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
