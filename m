Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab2C1WM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:12:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758110Ab2C1WMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:12:55 -0400
Date: Thu, 29 Mar 2012 00:12:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dave Jones <davej@redhat.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        keithp@keithp.com
Subject: Re: Corrupted files after suspend to disk
In-Reply-To: <20120312214914.GA8628@redhat.com>
Message-ID: <alpine.LNX.2.00.1203290011230.25526@pobox.suse.cz>
References: <jj5qhh$5j5$1@ID-44327.news.uni-berlin.de> <jj684d$6ng$1@ID-44327.news.uni-berlin.de> <CAFLxGvwazkbisZ0Ax==-Yyv2h5mYtnK-S2bOegZHX5g+rB2krQ@mail.gmail.com> <4F574113.8030906@01019freenet.de> <alpine.LRH.2.00.1203121300590.4911@twin.jikos.cz>
 <CAFLxGvwv159LHtyKdrF1DQZ-vQyagLJ9nNkcAZzkY4O9F-MwNg@mail.gmail.com> <alpine.LNX.2.00.1203121329430.18356@pobox.suse.cz> <CAFLxGvyXwFwLRYw7=eHGLZsiAB9Adcu16z=UPhLtL_Ze3bF-9g@mail.gmail.com> <alpine.LNX.2.00.1203121402460.18356@pobox.suse.cz>
 <4F5DF8F0.5010801@01019freenet.de> <20120312214914.GA8628@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012, Dave Jones wrote:

>  > https://bugzilla.novell.com/show_bug.cgi?id=732908
>  > 
>  > Following the link, you are able to compare the used chips - maybe there
>  > are some equal components?
> 
> This looks like the i915 corruption problem mentioned in a few other threads.
> 
> if you compare the hexdump of the good/bad files, you find that the corruption
> happens in 8x 4 byte writes of either 0x00000000 or 0x00aaaaaa.
> 
> KeithP clued me in last week that that looks like an ARGB pixel quad, so these
> writes are likely 8 pixel strips.

So this keeps happening to me on almost every resume still ... Keith, is 
there any way I could help you debug this?

-- 
Jiri Kosina
SUSE Labs
