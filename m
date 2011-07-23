Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1GWOVY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 10:21:24 -0400
Received: from bukvic.music.vt.edu ([198.82.152.114]:58178 "EHLO
	lists.linuxaudio.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab1GWOVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 10:21:18 -0400
Date: Sat, 23 Jul 2011 14:21:17 +0000
From: Fons Adriaensen <fons@linuxaudio.org>
To: Adrian Knoth <adi@drcomp.erfurt.thur.de>
Cc: Tom Gundersen <teg@jklm.no>,
        General Discussion about Arch Linux 
	<arch-general@archlinux.org>,
        Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [arch-general] Panic - no sound devices after upgrade
Message-ID: <20110723142117.GA21836@linuxaudio.org>
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

> > > If you want to try out Adrian's patch, I uploaded a kernel with the
> > > patch applied here:
> > > <https://dev.archlinux.org/~tomegun/kernel26-2.6.39.1.3-1.1-i686.pkg.tar.xz>.
> > 
> > Installed on two machines so far, more tomorrow.
> > Seems to have solved the problem :-) :-)
> 
> Good to know. I'll wait for your final confirmation and then commit it.

One problem: the gain settings have changed, now having a range of 0..64.
How do these values map to the internal ones (0..0xffff) ? I *hope* there
is value corresponding to EXACTLY 0x8000 (gain = 1) !!! The reason is
that MADI is bit-exact and is used to tranport other values than just
audio samples. This works of course only with exact unity gain.

BTW, why was this change made ? For pro users (are there other of this
card) this is a regression.

Ciao,

-- 
FA

