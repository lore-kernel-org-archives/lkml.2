Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab1KIMbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:31:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab1KIMbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:31:13 -0500
Date: Wed, 9 Nov 2011 10:30:50 -0200
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
Message-ID: <20111109123050.GC18207@ghostprotocols.net>
References: <20111108093225.GB32533@elte.hu> <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu> <20111108125609.GA14272@ghostprotocols.net> <4EB9315A.10806@redhat.com> <20111108143228.GC14272@ghostprotocols.net> <4EB94D08.3010207@redhat.com> <20111109085120.GD11473@elte.hu> <4EBA5881.7080409@redhat.com> <20111109115502.GA18207@ghostprotocols.net> <4EBA717A.8010300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBA717A.8010300@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 09, 2011 at 01:26:34PM +0100, Gerd Hoffmann escreveu:
>   Hi,
> 
> >>> Plus allowing full .perfconfig configurability of all the relevant 
> >>> colors, for those with special taste.
> >>
> >> Sure.  Maybe also allow multiple color sections and pick them by $TERM
> >> or --colors switch, i.e. [colors "xterm"].
> > 
> > Its fully configurable as of now, what we need is a set of .perfconfigs
> > that show how people think its better, we try it, set it as the default,
> > leave the others in tools/perf/Documentation/perfconfig/color.examples.
> 
> Yep, a set of examples works too.
> 
> The colors are not fully configurable yet though.  First, when switching
> all five colorsets to "default, default" there are still things which
> are colored (top bar, bottom bar, keys help display).  Second there is
> no way to set terminal attributes (i.e. "top = bold" or "selected =
> reverse").

Ok, adding those to the TODO list.

/me goes to check if http://perf.wiki.kernel.org is back working so that
we can have a _public_ TODO list, perhaps it may attract more
contributors :)

- Arnaldo
