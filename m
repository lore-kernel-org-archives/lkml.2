Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1ARJIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 04:08:37 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:33063 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab1ARJId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 04:08:33 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Paul Mundt'" <lethal@linux-sh.org>
Cc: <sfr@canb.auug.org.au>, "'Arnd Bergmann'" <arnd@arndb.de>,
        <gregkh@suse.de>, <jbarnes@virtuousgeek.org>,
        <dmitry.torokhov@gmail.com>, <dtor@mail.ru>, <rubini@cvml.unipv.it>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-next@vger.kernel.org>
References: <004901cbb4d5$b9bb1370$2d313a50$@mprc.pku.edu.cn> <20110118043323.GF2122@linux-sh.org>
In-Reply-To: <20110118043323.GF2122@linux-sh.org>
Subject: RE: Request for unicore32 architecture codes to merge into linux-next
Date: Tue, 18 Jan 2011 17:07:41 +0800
Message-ID: <01b501cbb6ef$3299f2a0$97cdd7e0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQKvmpDs5qji3UzzcGj9LCTNHzRliwD+9+G3kgZ2eSA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Paul Mundt [mailto:lethal@linux-sh.org]
> Sent: Tuesday, January 18, 2011 12:33 PM
> To: Guan Xuetao
> Cc: sfr@canb.auug.org.au; Arnd Bergmann; gregkh@suse.de; jbarnes@virtuousgeek.org; dmitry.torokhov@gmail.com; dtor@mail.ru;
> rubini@cvml.unipv.it; linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org; linux-fbdev@vger.kernel.org; linux-
> next@vger.kernel.org
> Subject: Re: Request for unicore32 architecture codes to merge into linux-next
> 
> On Sun, Jan 16, 2011 at 01:00:31AM +0800, Guan Xuetao wrote:
> >  drivers/staging/puv3/Kconfig                  |  125 ++
> >  drivers/staging/puv3/Makefile                 |   22 +
> >  drivers/staging/puv3/TODO                     |    7 +
> >  drivers/staging/puv3/i8042-ucio.h             |   89 ++
> >  drivers/staging/puv3/puv3-atkbd.h             |   43 +
> >  drivers/staging/puv3/puv3_ac97.c              |  369 +++++
> >  drivers/staging/puv3/puv3_i2c.c               |  309 ++++
> >  drivers/staging/puv3/puv3_pcm.c               |  435 ++++++
> >  drivers/staging/puv3/puv3_pcm.h               |   28 +
> >  drivers/staging/puv3/puv3_umal.c              | 2069 +++++++++++++++++++++++++
> >  drivers/staging/puv3/puv3_unifb.c             |  965 ++++++++++++
> 
> Staging is not a shortcut around having things reviewed or broken out
> logically. It's of course fine to merge the bulk of things in one go for
> when a new architecture is going on, but logically disparate parts still
> need to be broken out and sent to the proper places for review. It's
> obvious you haven't done this for any of the non-arch bits and hiding
> things under staging is not going to make this step any less necessary.
> 
> If you want your framebuffer driver reviewed, then split it out and
> submit it to the linux-fbdev list for review. Once that's had a going
> over and been Acked then of course it can be merged through whatever tree
> you like, and there's even a good chance that you don't need to bother
> with staging at all.
> 
> Using staging as a review circumvention measure however is just not going
> to fly.
I understand.
IMO, the whole architecture specific codes need to be merged first, and only some
necessary drivers are included under staging. Then, I could split the staging drivers
into corresponding mail-list, and then, additional drivers.
Otherwise, there are no architecture basic for drivers review.

Thanks
Guan Xuetao


