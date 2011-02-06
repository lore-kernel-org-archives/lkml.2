Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab1BFMVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:21:07 -0500
Received: from webbox4.loswebos.de ([213.187.93.205]:35890 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab1BFMVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:21:06 -0500
Date: Sun, 6 Feb 2011 13:21:01 +0100
From: Marc Koschewski <marc@osknowledge.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Jeff Chua <jeff.chua.linux@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Chris Wilson <chris@chris-wilson.co.uk>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
Message-ID: <20110206122101.GC22960@marc.osknowledge.org>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
 <20110206081950.GA12659@marc.osknowledge.org>
 <s5hei7lwhmg.wl%tiwai@suse.de>
 <AANLkTimURab9M5-LQxU0wjo=gEVBjHyv6osudadq4nNO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimURab9M5-LQxU0wjo=gEVBjHyv6osudadq4nNO@mail.gmail.com>
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E 38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.kosik.org/pubkey.asc
X-Blog: http://www.kosik.org/blog/
X-Operating-System: Linux marc 2.6.37-ck1-dezzy
User-Agent: Mutt/1.5.21hg (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've the NX stuff disabled, so to say DEBUG_RODATA=n and it doesn't resume... so
what's next?

I use an i7 with 32bit code as I think 64bit is a) useless for me and b) I just
plugged my old HDD into my new machine.

Marc

* Dave Airlie <airlied@gmail.com> [2011-02-06 21:06:18 +1000]:

> >>
> >> I reverted the specified commit and my box still suffers the
> >> resume-turns-into-cold-boot behavior. Retried two times with the commit reverted
> >> on top of HEAD...
> >
> > The cold-boot problem is very likely irrelevant with i915 patches.
> > I've got the same issue with and without the i915 fix patches on test
> > machines here.
> >
> Yeah its the 32-bit NX stuff most likely if you are using 32-bit kernels.
> 
> Dave.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
Marc Koschewski
