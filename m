Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721Ab0HLDpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 23:45:09 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:40119 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759710Ab0HLDpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 23:45:07 -0400
Date: Thu, 12 Aug 2010 05:45:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>, JBeulich@novell.com,
        aris@redhat.com, catalin.marinas@arm.com, jacmet@sunsite.dk,
        justinmattock@gmail.com, lizf@cn.fujitsu.com, ulfalizer.lkml@gmail.com,
        zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild: kconfig changes
Message-ID: <20100812034504.GA10211@merkur.ravnborg.org>
References: <20100804125156.GA23464@sepie.suse.cz> <AANLkTinN4npO7qfSa-42B-Cq5mKZX+--H0=1SuSrWTEP@mail.gmail.com> <20100807040101.GA30520@merkur.ravnborg.org> <AANLkTinOWBfsncSZw3bvHa6Mp+eb5dzibKSV15OKgW2M@mail.gmail.com> <20100811195131.GA24193@merkur.ravnborg.org> <20100811203453.GB28777@merkur.ravnborg.org> <AANLkTimcVwfq4Vm9TjY0vyvJcHpvHt+DzO73=a7693mx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimcVwfq4Vm9TjY0vyvJcHpvHt+DzO73=a7693mx@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 04:39:35PM -0700, Arve Hj?nnev?g wrote:
> On Wed, Aug 11, 2010 at 1:34 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> >>
> >> Unfortunately the bug I had discovered is another bug.
> >> If I do:
> >>       make ARCH=avr32 atngw100_defconfig
> >>       make ARCH=avr32 savedefconfig
> >>       cp defconfig arch/avr32/configs/atngw100_defconfig
> >>       make ARCH=avr32 atngw100_defconfig
> >>       diff -u .config .config.old
> >>
> >> then the diff shows an unexpected difference.
> >>
> >> I will continue of that issue.
> > Fixed it - see patch below.
> >
> > @Michal - I will do a proper patch submission if Arve
> > can confirm that the problem he saw has been fixed
> > with these patches.
> >
> 
> Your first patch fixes the problem I saw.
Thanks.
I will add the following to the commit:
Reported-by: Arve Hj?nnev?g <arve@android.com>
Tested-by: Arve Hj?nnev?g <arve@android.com>

	Sam
