Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab1B0EeQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:34:16 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:34469 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab1B0EeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:34:13 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "'Greg KH'" <greg@kroah.com>
References: <02f301cbcb48$bebea4c0$3c3bee40$@mprc.pku.edu.cn> <201102171831.16713.arnd@arndb.de> <018c01cbd29b$759a4740$60ced5c0$@mprc.pku.edu.cn> <201102221621.07655.arnd@arndb.de>
In-Reply-To: <201102221621.07655.arnd@arndb.de>
Subject: RE: [PATCHv2 09/11] unicore32 core architecture: timer and time handling
Date: Sun, 27 Feb 2011 12:34:01 +0800
Message-ID: <017f01cbd637$8f360aa0$ada21fe0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQH8AKscRheQ/HHApBgo+X/sOK9QJQIXuRX2AZUULXEDBnuK7JN+02uQ
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Tuesday, February 22, 2011 11:21 PM
> To: Guan Xuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; 'Greg KH'
> Subject: Re: [PATCHv2 09/11] unicore32 core architecture: timer and time handling
> 
> On Tuesday 22 February 2011, Guan Xuetao wrote:
> > > > +#if defined(CONFIG_PUV3_DB0913)                \
> > > > +       || defined(CONFIG_PUV3_NB0916)  \
> > > > +       || defined(CONFIG_PUV3_SMW0919)
> > > > +
> > > > +#define  CLOCK_TICK_RATE         (14318000)
> > > > +
> > > > +#endif
> > >
> > > I believe that we don't use CLOCK_TICK_RATE in the kernel any more,
> > > so there is no reason to define it.
> > CLOCK_TICK_RATE is an important value for the kernel.
> > And perhaps I misunderstanding your meaning...
> 
> We just discussed the same thing for a new ARM platform. You are
> right that CLOCK_TICK_RATE is currently still being used, but
> we are trying to get rid of it.
> 
> Most importantly, it should not be configuration specific any more.
> If you use CLOCK_TICK_RATE in unicore32 specific code, it would
> be best to rename that variable and device it in a board specific
> file.
> 
> The definition in timex.h can basically contain any value that is
> a multiple of CONFIG_HZ. Don't worry about this one, we will fix
> it for good for the entire kernel.
> 
> 	Arnd
Ok, I see.

Thanks & Regards.
Guan Xuetao

