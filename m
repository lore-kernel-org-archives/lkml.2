Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab0HQQU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:20:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57329 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757911Ab0HQQUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:20:55 -0400
Date: Tue, 17 Aug 2010 18:20:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chris Frey <cdfrey@foursquare.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: compiler warnings in 2.6.35.2
Message-ID: <20100817162052.GA12785@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Chris Frey <cdfrey@foursquare.net>, linux-kernel@vger.kernel.org,
	hpa@zytor.com
References: <20100817021252.GA17647@foursquare.net>
 <20100817053456.GA32714@liondog.tnic>
 <20100817062801.GA24978@foursquare.net>
 <20100817063159.GC32714@liondog.tnic>
 <20100817155333.GA17624@foursquare.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100817155333.GA17624@foursquare.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Frey <cdfrey@foursquare.net>
Date: Tue, Aug 17, 2010 at 11:53:33AM -0400

> > > > >   CC      mm/swap.o
> > > > > In file included from include/linux/kobject.h:21,
> > > > >                  from include/linux/sched.h:91,
> > > > >                  from mm/swap.c:17:
> > > > > include/linux/sysfs.h:183: warning: parameter has incomplete type
> > > > > /home/cdfrey/kernel/git/linux/arch/x86/include/asm/cpufeature.h: In function `__static_cpu_has':
> > > > > /home/cdfrey/kernel/git/linux/arch/x86/include/asm/cpufeature.h:315: warning: asm operand 1 probably doesn't match constraints
> > > > 
> > > > Which compiler version are you using?
> > > 
> > > GCC 3.3
> > 
> > Any chance to upgrade to a 4.x version?
> 
> I could, but Documentation/Changes says gcc 3.2 is the minimum, so I hoped
> 3.3 would be sufficient.

This is actually something we're looking to change now:
http://lkml.indiana.edu/hypermail/linux/kernel/1005.2/01239.html

@hpa: there are some gcc3.x users left, obviously.

> 
> As for the first warning, doesn't it just need include/linux/kobject.h
> to be included for the enum type?

This is a gcc 3.x problem AFAIK.

> As for the second warning, I'm not sure I even understand it.

Ditto.

So why do you want to stay with 3.x anyway?

-- 
Regards/Gruss,
Boris.
