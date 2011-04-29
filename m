Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760495Ab1D2Rfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:35:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:44564 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810Ab1D2Rfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:35:36 -0400
Date: Fri, 29 Apr 2011 14:35:21 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/18] RAS daemon: Easter Eggs Edition
Message-ID: <20110429173521.GB3273@ghostprotocols.net>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
 <20110429140844.GB1768@nowhere>
 <20110429142534.GD18746@aftab>
 <20110429143145.GB10590@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110429143145.GB10590@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Apr 29, 2011 at 04:31:45PM +0200, Ingo Molnar escreveu:
> 
> * Borislav Petkov <bp@amd64.org> wrote:
> 
> > On Fri, Apr 29, 2011 at 10:08:48AM -0400, Frederic Weisbecker wrote:
> > > 
> > > If you want to accelerate that, I suggest you cut your patchset into 
> > > smaller sets and focus on merging them piece by piece. Few people are going 
> > > to review 18 patches at once. They may plan to scatter their review over 
> > > days but that doesn't scale well, and it naturally reduces the number of 
> > > reviewers.
> > > 
> > > You could start with exporting trace things into tools/trace, post the few 
> > > concerned patches and iterate them until everyone is happy. Then switch to 
> > > another subset of the big thing.
> > 
> > Hi Frederic,
> > 
> > I can definitely do that. I just wanted to know before I do it though, 
> > whether the general direction is ok and whether people are fine with the 
> > changes, i.e. Arnaldo, Ingo, Peter, Steven, any reactions? If yes, I can get 
> > to work and split the big pile into more digestible pieces.
> 
> I definitely like the general approach, it's a big step forward from mcelog. 
> Might make sense to progress to the small digestible patches stage to get out 
> the detailed reviews?

+1
 
> Thanks,
> 
> 	Ingo
