Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab1GVThN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:37:13 -0400
Received: from bukvic.music.vt.edu ([198.82.152.114]:36909 "EHLO
	lists.linuxaudio.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab1GVThL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:37:11 -0400
Date: Fri, 22 Jul 2011 19:37:10 +0000
From: Fons Adriaensen <fons@linuxaudio.org>
To: Tom Gundersen <teg@jklm.no>
Cc: General Discussion about Arch Linux <arch-general@archlinux.org>,
        Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Adrian Knoth <adi@drcomp.erfurt.thur.de>
Subject: Re: [arch-general] Panic - no sound devices after upgrade
Message-ID: <20110722193710.GA8452@linuxaudio.org>
References: <20110720153023.GA11502@linuxaudio.org> <CAFEhRJczj=_B7fK7GvBEnqpB2GJGnCnGkoA2w5vzbFfM2wAGZw@mail.gmail.com> <20110720163844.GB16901@linuxaudio.org> <CAG-2HqWqATSJ=oJTTvULXwPEG82yN+8e6GJFs759hPA-=krAOQ@mail.gmail.com> <20110721100944.GA13971@linuxaudio.org> <CAG-2HqX23C79vfccnu0tMqx+6K9Z5pS0_HekaLizQx7XfkPQ1Q@mail.gmail.com> <20110721112331.GA15059@linuxaudio.org> <CAG-2HqWK3x5-szkyzX8AMxuMpDZNVRXHYtQ0AkAPMsGcLK0Z9w@mail.gmail.com> <4E28313E.60900@drcomp.erfurt.thur.de> <CAG-2HqVew75LE68fObz7e3WwcT-5Gwu1ka9Zr4vb1JdbSUOYEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG-2HqVew75LE68fObz7e3WwcT-5Gwu1ka9Zr4vb1JdbSUOYEQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 07:25:56PM +0200, Tom Gundersen wrote:
 
> Fons (or anyone else who could reproduce the problem),
> 
> If you want to try out Adrian's patch, I uploaded a kernel with the
> patch applied here:
> <https://dev.archlinux.org/~tomegun/kernel26-2.6.39.1.3-1.1-i686.pkg.tar.xz>.

Installed on two machines so far, more tomorrow.
Seems to have solved the problem :-) :-)

An unrelated question: I see references to the RME Raydat
interface. Does that mean it's supported ? Also with period
sizes < 1024 ?


Ciao,

-- 
FA

