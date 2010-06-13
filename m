Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab0FMLCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 07:02:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58146 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab0FMLCq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 07:02:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Suspend hangs since 2.6.34
Date: Sun, 13 Jun 2010 13:00:49 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Tino Keitel <tino.keitel+xorg@tikei.de>, intel-gfx@lists.freedesktop.org,
       linux-kernel@vger.kernel.org,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <20100609175356.GA17332@x61.home> <201006100142.13131.rjw@sisk.pl> <4C108091.3060204@msgid.tls.msk.ru>
In-Reply-To: <4C108091.3060204@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006131300.49997.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 10, 2010, Michael Tokarev wrote:
> 10.06.2010 03:42, Rafael J. Wysocki пишет:
> > On Wednesday, June 09, 2010, Tino Keitel wrote:
> >> Hi,
> >>
> >> as of kernel 2.6.34 I sometimes get a strange hang during suspend to
> >> RAM. After echo mem>  /sys/power/state, the suspend script hangs, Xorg
> >> eats 100% CPU, and the desktop is frozen. I can kill the script and the
> >> computer will then suspend and resume fine. The kernel log shows
> >> nothing interesting when the hang happens:
> >>
> >> usblp0: removed
> >> usbcore: deregistering interface driver dvb_usb_vp7045
> >> dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II)
> >> successfully deinitialized and disconnected.
> >> PM: Syncing filesystems ... done.
> 
> Sounds very much like the problem I have with 2.6.34 final.  Did not
> happen with 2.6.34-rc7 which suspended just fine, but happens quite
> regularly on 2.6.34 final - not every suspend but each 2nd or 3rd
> attempt.  I stopped doing suspend-to-ram due to this, because it's
> unreliable.  Suspend-to-disk works just fine.

Can you both try to do "echo 0 > /sys/power/pm_async" and check if suspend
works with that?

Rafael
