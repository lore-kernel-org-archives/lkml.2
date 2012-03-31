Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab2CaUVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 16:21:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab2CaUVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 16:21:30 -0400
Date: Sat, 31 Mar 2012 22:21:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Jones <davej@redhat.com>,
        Andreas Hartmann <andihartmann@01019freenet.de>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: Corrupted files after suspend to disk
In-Reply-To: <alpine.LNX.2.00.1203291723040.25526@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1203312219560.25526@pobox.suse.cz>
References: <jj5qhh$5j5$1@ID-44327.news.uni-berlin.de> <jj684d$6ng$1@ID-44327.news.uni-berlin.de> <CAFLxGvwazkbisZ0Ax==-Yyv2h5mYtnK-S2bOegZHX5g+rB2krQ@mail.gmail.com> <4F574113.8030906@01019freenet.de> <alpine.LRH.2.00.1203121300590.4911@twin.jikos.cz>
 <CAFLxGvwv159LHtyKdrF1DQZ-vQyagLJ9nNkcAZzkY4O9F-MwNg@mail.gmail.com> <alpine.LNX.2.00.1203121329430.18356@pobox.suse.cz> <CAFLxGvyXwFwLRYw7=eHGLZsiAB9Adcu16z=UPhLtL_Ze3bF-9g@mail.gmail.com> <alpine.LNX.2.00.1203121402460.18356@pobox.suse.cz>
 <4F5DF8F0.5010801@01019freenet.de> <20120312214914.GA8628@redhat.com> <alpine.LNX.2.00.1203290011230.25526@pobox.suse.cz> <868vikwdc9.fsf@sumi.keithp.com> <alpine.LNX.2.00.1203291723040.25526@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012, Jiri Kosina wrote:

> > > So this keeps happening to me on almost every resume still ... Keith, is 
> > > there any way I could help you debug this?
> > 
> > Let me know what you find with Dave's patch -- it's the most promising
> > lead we've had. We've had no luck reproducing this at Intel, though a
> > couple of engineers have been trying to make it happen for several days
> > now...
> 
> Running with it now, will let you know in a couple of days to be 
> reasonably certain about the outcome.

Okay, it seems to fix the issues I have been seeing on my system.

FWIW,

	Tested-by: Jiri Kosina <jkosina@suse.cz>

Thanks,

-- 
Jiri Kosina
SUSE Labs
