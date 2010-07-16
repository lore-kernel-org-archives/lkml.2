Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965126Ab0GPLGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 07:06:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49173 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965106Ab0GPLGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 07:06:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 3/6] autofs/autofs4: move compat_ioctl handling into fs
Date: Fri, 16 Jul 2010 13:05:31 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "autofs@linux.kernel.org" <autofs@linux.kernel.org>
References: <1278195310-25590-1-git-send-email-arnd@arndb.de> <AANLkTimVzSzCl2XfWBg5HauYtIT5znxkm6M0yo_1en2b@mail.gmail.com> <1279255230.2968.24.camel@localhost>
In-Reply-To: <1279255230.2968.24.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007161305.31291.arnd@arndb.de>
X-Provags-ID: V02:K0:vpbGBtKF2eHd1kjcEEqO++TZKHwLtJEO4Tg5n+1RHBc
 pY003j1RYy5+i+OFIibrGxfidG7muURYIWgWlIAB/3HXdKZj4Q
 uTaD5wm4mP4PjFFFP9Ss3fi4jVZAJbQtxac7IWO8423HRRM0Gd
 5lILCRjyqOgiCUT7VDLpqbQhdbgW+07EuSwqLZBz2Xs6OT4SgS
 ohnM4xvCTCGUpbGaUp4BA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 July 2010, Ian Kent wrote:
> On Fri, 2010-07-16 at 02:14 +0200, Frederic Weisbecker wrote:
> > 2010/7/6 Ian Kent <raven@themaw.net>:
> > In any case, can we let you handle this patch for 2.6.36 inclusion?
> 
> I think it makes more sense to keep these common patches together so
> Arnd probably should keep it with his series.

I think that's fine. Takashi Iwai took the alsa patch, but the
rest can probably be merged together.

Frederic, would you like to add the remaining ioctl removal series
into your git tree and have Stephen pull that into linux-next?
I believe he's still pulling your tree anyway, although it doesn't
have much content at the moment.

	Arnd
