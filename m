Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab0GER1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 13:27:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:36994 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751422Ab0GER1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 13:27:21 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX18qrOcAghMqiIb+xulx+uM4OgcHP1LVVHRNHAE5f2
	sHELmainb2izzu
From: Marvin <marvin24@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Radeon KMS doesn't work.
Date: Mon, 5 Jul 2010 19:27:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.5; x86_64; ; )
References: <20100703221056.GA17817@animx.eu.org> <20100704231926.GA1780@animx.eu.org>
In-Reply-To: <20100704231926.GA1780@animx.eu.org>
Cc: xorg-driver-ati@lists.x.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007051927.17001.marvin24@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Wakko,

as nobody seems to have answered yet, I think it's better that you file a bug 
against the radeon driver (bugs.freedesktop.org, one bug for each defect). 
There may be similar bugs already, so please check this also.

Thanks

Marvin

Am Montag 05 Juli 2010, 01:19:26 schrieb Wakko Warner:
> Wakko Warner wrote:
> > I have a Dell Inspiron 5100 with an ATI Radeon Mobility M7 (7500 R100
> > PCI ID 1002:4c57 sub 1028:0149).
> > 
> > Immediately when radeon.ko is loaded, the screen goes blank (The
> > backlight stays on).  I have fbcon compiled into the kernel (I also
> > tried as module). I am unable to get the screen to work again until I
> > reboot.  The logs did not appear to have any errors after the module
> > loaded.  The system was still responsive on the network.
> > 
> > I tried kernels 2.6.33 and 2.6.34.
> > 
> > I can provide kernel output if needed.
> 
> I need to add that if I use modeset=0, the screen does not blank.
> 
> Also 2.6.34 (with modeset=0) doesn't do 3D very well on this system.  Some
> objects look ok, some are garbled, some do not appear at all.  The gears
> from xscreensaver does not show up at all.

