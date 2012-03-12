Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab2CLMDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:03:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463Ab2CLMDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:03:20 -0400
Date: Mon, 12 Mar 2012 13:03:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: Corrupted files after suspend to disk
In-Reply-To: <4F574113.8030906@01019freenet.de>
Message-ID: <alpine.LRH.2.00.1203121300590.4911@twin.jikos.cz>
References: <201202162251.47063.rjw@sisk.pl> <Pine.LNX.4.44L0.1202161722310.1150-100000@iolanthe.rowland.org> <CAFLxGvwWBWTmv+uUH87UB3Ly31hjVU5kWpSyihGDKj6_8oc6WA@mail.gmail.com> <201202170016.14313.rjw@sisk.pl> <jj5qhh$5j5$1@ID-44327.news.uni-berlin.de>
 <jj684d$6ng$1@ID-44327.news.uni-berlin.de> <CAFLxGvwazkbisZ0Ax==-Yyv2h5mYtnK-S2bOegZHX5g+rB2krQ@mail.gmail.com> <4F574113.8030906@01019freenet.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, Andreas Hartmann wrote:

> > On my system kernel suspend *seems* to work.
> > I've seen no corrupted files so far.
> > 
> > But sometimes the resume is failing. (One out of 5 resumes fails).
> > I was unable to get any kernel output.
> > 
> > So I'm not sure whether this is the same issue
> > or another one. :-\
> 
> I'm pretty sure that this is the same issue. What you are telling
> correlates with my research here.
> I even got resumes where the machine came up again, but nothing could be
> done (it wasn't possible to switch of the password secured screen saver
> any more - login at the shell wasn't possible, too, because the started
> bash crashed), 

This is happening to me as well. Something like 1 resume out of 5 goes 
wrong this very same way. 

This is thinkpad x200s.

All the userspace is segfaulting all over the place (most frequently in 
libselinux for some reason).

I am not able to verify the 'drop_caches' theory, as I can't invoke a 
single command that wouldn't crash.

-- 
Jiri Kosina
SUSE Labs

