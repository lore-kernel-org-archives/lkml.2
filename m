Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab1GYP0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:26:12 -0400
Received: from bukvic.music.vt.edu ([198.82.152.114]:36670 "EHLO
	lists.linuxaudio.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1GYP0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:26:09 -0400
Date: Mon, 25 Jul 2011 15:26:07 +0000
From: Fons Adriaensen <fons@linuxaudio.org>
To: Adrian Knoth <adi@drcomp.erfurt.thur.de>
Cc: Tom Gundersen <teg@jklm.no>,
        General Discussion about Arch Linux 
	<arch-general@archlinux.org>,
        Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [arch-general] Panic - no sound devices after upgrade
Message-ID: <20110725152607.GA22683@linuxaudio.org>
References: <20110720163844.GB16901@linuxaudio.org> <CAG-2HqWqATSJ=oJTTvULXwPEG82yN+8e6GJFs759hPA-=krAOQ@mail.gmail.com> <20110721100944.GA13971@linuxaudio.org> <CAG-2HqX23C79vfccnu0tMqx+6K9Z5pS0_HekaLizQx7XfkPQ1Q@mail.gmail.com> <20110721112331.GA15059@linuxaudio.org> <CAG-2HqWK3x5-szkyzX8AMxuMpDZNVRXHYtQ0AkAPMsGcLK0Z9w@mail.gmail.com> <4E28313E.60900@drcomp.erfurt.thur.de> <CAG-2HqVew75LE68fObz7e3WwcT-5Gwu1ka9Zr4vb1JdbSUOYEQ@mail.gmail.com> <20110722193710.GA8452@linuxaudio.org> <20110722231430.GN3771@ltw.loris.tv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722231430.GN3771@ltw.loris.tv>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 01:14:30AM +0200, Adrian Knoth wrote:

> > > Fons (or anyone else who could reproduce the problem),
> > > 
> > > If you want to try out Adrian's patch, I uploaded a kernel with the
> > > patch applied here:
> > > <https://dev.archlinux.org/~tomegun/kernel26-2.6.39.1.3-1.1-i686.pkg.tar.xz>.
> > 
> > Installed on two machines so far, more tomorrow.
> > Seems to have solved the problem :-) :-)
> 
> Good to know. I'll wait for your final confirmation and then commit it.

More news, not all good. After trying out all combinations and doing it
again to be sure it seems that:

* kernel26-2.6.39.1.3-1.1-i686.pkg.tar.xz and its hdspm driver work well
on the five machines that have cards with firmware revision CC.

* With newer cards (they arrived just two weeks ago) with revision CF
things seem to work but there are crackles in the sound - not loud but
clear enough. Sounds like single samples being modified every now and
then.

    - Older cards on the same machine with the same kernel work fine.
    - Kernel 2.6.37 on the same machine with the new cards works fine
      as well.

So there must have been some regression.

For now I have to revert two machines (those using the new cards) to
2.6.37. 

Ciao,

-- 
FA

