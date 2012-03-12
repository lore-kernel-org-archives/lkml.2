Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab2CLMaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:30:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab2CLMa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:30:27 -0400
Date: Mon, 12 Mar 2012 13:30:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: Corrupted files after suspend to disk
In-Reply-To: <CAFLxGvwv159LHtyKdrF1DQZ-vQyagLJ9nNkcAZzkY4O9F-MwNg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1203121329430.18356@pobox.suse.cz>
References: <201202162251.47063.rjw@sisk.pl> <Pine.LNX.4.44L0.1202161722310.1150-100000@iolanthe.rowland.org> <CAFLxGvwWBWTmv+uUH87UB3Ly31hjVU5kWpSyihGDKj6_8oc6WA@mail.gmail.com> <201202170016.14313.rjw@sisk.pl> <jj5qhh$5j5$1@ID-44327.news.uni-berlin.de>
 <jj684d$6ng$1@ID-44327.news.uni-berlin.de> <CAFLxGvwazkbisZ0Ax==-Yyv2h5mYtnK-S2bOegZHX5g+rB2krQ@mail.gmail.com> <4F574113.8030906@01019freenet.de> <alpine.LRH.2.00.1203121300590.4911@twin.jikos.cz>
 <CAFLxGvwv159LHtyKdrF1DQZ-vQyagLJ9nNkcAZzkY4O9F-MwNg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012, richard -rw- weinberger wrote:

> > This is happening to me as well. Something like 1 resume out of 5 goes
> > wrong this very same way.
> >
> > This is thinkpad x200s.
> >
> > All the userspace is segfaulting all over the place (most frequently in
> > libselinux for some reason).
> >
> > I am not able to verify the 'drop_caches' theory, as I can't invoke a
> > single command that wouldn't crash.
> 
> The question is how should we proceed?
> I've reported this issue one year (!!!) ago.

Hmm, 3.3-rcX seems to be the first version when it started to happen to 
me. I take it that you have seen this also with 3.2? 3.1?

-- 
Jiri Kosina
SUSE Labs
