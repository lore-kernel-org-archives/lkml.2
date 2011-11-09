Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab1KIMdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:33:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164Ab1KIMdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:33:51 -0500
Date: Wed, 9 Nov 2011 10:33:26 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Theodore Tso <tytso@mit.edu>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git
	repository, tools/perf/ and tools/kvm/
Message-ID: <20111109123326.GD18207@ghostprotocols.net>
References: <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu> <20111108125609.GA14272@ghostprotocols.net> <4EB9315A.10806@redhat.com> <20111108143228.GC14272@ghostprotocols.net> <4EB94D08.3010207@redhat.com> <20111109085120.GD11473@elte.hu> <4EBA5881.7080409@redhat.com> <20111109115502.GA18207@ghostprotocols.net> <4EBA717A.8010300@redhat.com> <20111109123050.GC18207@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109123050.GC18207@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 09, 2011 at 10:30:50AM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Wed, Nov 09, 2011 at 01:26:34PM +0100, Gerd Hoffmann escreveu:
> > > Its fully configurable as of now, what we need is a set of .perfconfigs
> > > that show how people think its better, we try it, set it as the default,
> > > leave the others in tools/perf/Documentation/perfconfig/color.examples.

> > Yep, a set of examples works too.

> > The colors are not fully configurable yet though.  First, when switching
> > all five colorsets to "default, default" there are still things which
> > are colored (top bar, bottom bar, keys help display).  Second there is
> > no way to set terminal attributes (i.e. "top = bold" or "selected =
> > reverse").

> Ok, adding those to my TODO list.

> /me goes to check if http://perf.wiki.kernel.org is back working so that
> we can have a _public_ TODO list, perhaps it may attract more
> contributors :)

Oops, there is one, utterly old tho ;-\

I tried changing that and adding this entry but:

https://perf.wiki.kernel.org/articles/u/s/e/Special~UserLogin_94cd.html

Returns:

The requested URL /articles/u/s/e/Special~UserLogin_94cd.html was not
found on this server.

Ingo, would that G+ page be useful for that?

- Arnaldo
