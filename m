Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab1GVXOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 19:14:49 -0400
Received: from ltw.loris.tv ([85.14.220.160]:57697 "EHLO ltw.loris.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab1GVXOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 19:14:48 -0400
Date: Sat, 23 Jul 2011 01:14:30 +0200
From: Adrian Knoth <adi@drcomp.erfurt.thur.de>
To: Fons Adriaensen <fons@linuxaudio.org>
Cc: Tom Gundersen <teg@jklm.no>,
        General Discussion about Arch Linux 
	<arch-general@archlinux.org>,
        Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [arch-general] Panic - no sound devices after upgrade
Message-ID: <20110722231430.GN3771@ltw.loris.tv>
References: <CAFEhRJczj=_B7fK7GvBEnqpB2GJGnCnGkoA2w5vzbFfM2wAGZw@mail.gmail.com> <20110720163844.GB16901@linuxaudio.org> <CAG-2HqWqATSJ=oJTTvULXwPEG82yN+8e6GJFs759hPA-=krAOQ@mail.gmail.com> <20110721100944.GA13971@linuxaudio.org> <CAG-2HqX23C79vfccnu0tMqx+6K9Z5pS0_HekaLizQx7XfkPQ1Q@mail.gmail.com> <20110721112331.GA15059@linuxaudio.org> <CAG-2HqWK3x5-szkyzX8AMxuMpDZNVRXHYtQ0AkAPMsGcLK0Z9w@mail.gmail.com> <4E28313E.60900@drcomp.erfurt.thur.de> <CAG-2HqVew75LE68fObz7e3WwcT-5Gwu1ka9Zr4vb1JdbSUOYEQ@mail.gmail.com> <20110722193710.GA8452@linuxaudio.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722193710.GA8452@linuxaudio.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 07:37:10PM +0000, Fons Adriaensen wrote:

> > Fons (or anyone else who could reproduce the problem),
> > 
> > If you want to try out Adrian's patch, I uploaded a kernel with the
> > patch applied here:
> > <https://dev.archlinux.org/~tomegun/kernel26-2.6.39.1.3-1.1-i686.pkg.tar.xz>.
> 
> Installed on two machines so far, more tomorrow.
> Seems to have solved the problem :-) :-)

Good to know. I'll wait for your final confirmation and then commit it.

> An unrelated question: I see references to the RME Raydat
> interface. Does that mean it's supported ? Also with period
> sizes < 1024 ?

It is. It's actually the card I'm developing on. So far, all period
sizes from 64 to 8k (iirc) work. I don't know if 32 is supposed to work,
at least on my machine, it doesn't.


HTH

-- 
mail: adi@thur.de  	http://adi.thur.de	PGP/GPG: key via keyserver
