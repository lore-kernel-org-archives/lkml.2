Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab1BDHDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 02:03:25 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45080 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab1BDHDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 02:03:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WFaBFfDsS73j/LGDkfofY3dtuZr/+gxoaXfbAuWLSgIcBi/jw0VF2bbhuSuC5ufmgN
         vVAjmPebx0rge/PDAWxqbURHYR0r+Wj8s5KAXODfFtwnZ1L/imGUdppdf7JE03i61gNj
         5HTVfGcjLVdEEfcn3i0y9bzM6FYCNNEI18OXE=
Date: Fri, 4 Feb 2011 08:05:46 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@gmail.com>,
        Dave Airlie <airlied@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Takashi Iwai <tiwai@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Subject: Re: 2.6.38-rc3-git1: Reported regressions 2.6.36 -> 2.6.37
Message-ID: <20110204070546.GA12621@linux-yscl.site>
References: <e9vOd5LzdBK.A.dyD.h6eSNB@chimera>
 <AANLkTikELiGS+fM5WguZS=Fo-sSXmej1UnKWqCFmnE0k@mail.gmail.com>
 <s5haaid3xos.wl%tiwai@suse.de>
 <201102032009.17100.rjw@sisk.pl>
 <AANLkTi=suS1VDL=6EtT0D2=0c1DWwxdwZBBv=-BySNX-@mail.gmail.com>
 <AANLkTi=7EOih=fY5FCvhQbewSc=3a49cYVaKJRWM+-3d@mail.gmail.com>
 <AANLkTin7kBur95H=UBcYEcjYsUkrdG8znX-7PFZ4rrHf@mail.gmail.com>
 <AANLkTimQPPDyBwkN0HWM2+bPcbzVd8YHZvn2iR8MVzfL@mail.gmail.com>
 <yund3n88v7x.fsf@aiko.keithp.com>
 <AANLkTin-9a5Z3qq4t8UakRvgB1G3_CT2RLKMVaHXvnLr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin-9a5Z3qq4t8UakRvgB1G3_CT2RLKMVaHXvnLr@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu  3.Feb'11 at 17:11:14 -0800, Linus Torvalds wrote:
> On Thu, Feb 3, 2011 at 5:05 PM, Keith Packard <keithp@keithp.com> wrote:
> >
> > The goal is to make it so that when you *do* set a mode, DPMS gets set
> > to ON (as the monitor will actually be "on" at that point). Here's a
> > patch which does the DPMS_ON precisely when setting a mode.
> 
> Ok, patch looks sane, but it does leave me with the "what about the
> 'fb_changed' case?" question. Is that case basically guaranteed to not
> change any existing dpms state?
> 
> > (note, this patch compiles, but is otherwise only lightly tested).
> 
> Carlos? Takashi? Ignore my crazy patch, try this one instead. Does it
> fix things for you?

Yes! (tested on top of 2.6.38-rc3+).

Thanks to everyone involved!

