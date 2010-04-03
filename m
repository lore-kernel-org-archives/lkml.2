Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab0DCKio (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 06:38:44 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53617 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab0DCKik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 06:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vRZZSuMId6JmsLImsYIBJdLf4CP6/pISQjiXKhY0BSfbs/YD0ep1sqGgYoJ3XwbrhL
         6YvdbYsn7ev6J89vh2V+OZpLZRZPWTtbWBDeBhQozp/QGai0wuyQyVS1LOSrU4qIJSXJ
         g9Gsl7hK/duRKkHHZeCwytdDAX+0s5bqQ4D4I=
Date: Sat, 3 Apr 2010 12:38:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [GIT PULL v3] perf fixes
Message-ID: <20100403103829.GC5172@nowhere>
References: <1270007927-6391-1-git-send-regression-fweisbec@gmail.com> <20100401071742.GB5207@nowhere> <20100402173203.GA11712@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402173203.GA11712@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 07:32:03PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Wed, Mar 31, 2010 at 05:58:45AM +0200, Frederic Weisbecker wrote:
> > > Ingo,
> > > 
> > > Please pull the perf/urgent branch that can be found at:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > > 	perf/urgent
> > 
> > 
> > I have updated the tree. There was a leftover patch for perf/core
> > inside (not listed here). Also, since you've merged linus tree in
> > perf/urgent lately, I've zapped my merge commit. Other than that,
> > the three fixes remain.
> > 
> > Thanks.
> 
> Pulled, thanks Frederic!
> 
> Note, i also queued up this patch from Edwin:
> 
>   257ef9d: perf, x86: Fix callgraphs of 32-bit processes on 64-bit kernels
> 
> with your Acked-by added.
> 
> Thanks,
> 
> 	Ingo


Ah ok. I was too cautious and eventually queued it for perf/core, but
if you think it's fine, no problem.

Thanks.

