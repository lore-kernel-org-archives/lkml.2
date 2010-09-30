Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab0I3BMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 21:12:25 -0400
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:48734 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373Ab0I3BMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 21:12:24 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-08.arcor-online.net B0765205571
Subject: Re: [GIT PULL for 2.6.36] V4L/DVB fixes
From: hermann pitton <hermann-pitton@arcor.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTikYyEPAHq5rYzzckExTSFFCAj_DUqAZEvoeU0WD@mail.gmail.com>
References: <4CA10545.4010204@redhat.com>
	 <AANLkTikYyEPAHq5rYzzckExTSFFCAj_DUqAZEvoeU0WD@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 30 Sep 2010 03:04:50 +0200
Message-Id: <1285808690.4880.18.camel@pc07.localdom.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Am Montag, den 27.09.2010, 17:02 -0700 schrieb Linus Torvalds:
> On Mon, Sep 27, 2010 at 1:57 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > The following changes since commit 32163f4b2cef28a5aab8b226ffecfc6379a53786:
> >
> >  alpha: fix usp value in multithreaded coredumps (2010-09-25 14:38:13 -0700)
> >
> > are available in the git repository at:
> >  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus
> 
> I get
> 
>   scripts/kconfig/conf --oldconfig arch/x86/Kconfig
>   drivers/media/Kconfig:146: 'endif' in different file than 'if'
>   drivers/media/IR/Kconfig:15: location of the 'if'
>   drivers/Kconfig:114: unexpected 'endmenu' within if block
>   drivers/Kconfig:1: missing end statement for this entry
>   make[1]: *** [oldconfig] Error 1
>   make: *** [oldconfig] Error 2
> 
> with this. And it seems to be due to a totally broken commit at the
> very beginning of the series by a commit called "Kconfig fixes"
> (Hah!), that clearly has not been tested at all.
> 
> The commit sequence was also done today, apparently immediately before
> sending me the pull request. Which sure as hell explains the "clearly
> not tested at all" situation.
> 
> Don't do this. You are now officially on my shit-list for sending me
> total crap.
> 
> How effing hard can it be to understand: you don't send me stuff that
> hasn't been tested. It needs to be in -next for SEVERAL DAYS, and you
> don't rebase it or take it from some random quilt series just before
> sending it to me.
> 
> That's true _especially_ during the -rc series. But it's damn well
> true at any other time too.
> 
> I'm angry. I expect at least some _minimal_ amount of competence from
> people I pull from. This was not it. Get your ^&#! act together!
> 
>                                    Linus

you should not be such rude.

You have never been in any hardware details on v4l and dvb.

After Gerd Knorr did quit, out of reasons, you noticed there is some
noise on v4l and dvb, but you never had to fix much on your own in the
last eight years.

Shouting around and blaming others always was enough ...

I agree, a rc-1 should be at least compile tested.

Any idea, why this goes away?

Cheers,
Hermann










