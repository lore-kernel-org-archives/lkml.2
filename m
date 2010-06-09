Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab0FIXoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 19:44:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44696 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab0FIXoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 19:44:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Organization: SiSK
To: Tino Keitel <tino.keitel+xorg@tikei.de>
Subject: Re: Suspend hangs since 2.6.34
Date: Thu, 10 Jun 2010 01:42:12 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc2-rjw+; KDE/4.4.3; x86_64; ; )
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <20100609175356.GA17332@x61.home>
In-Reply-To: <20100609175356.GA17332@x61.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006100142.13131.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 09, 2010, Tino Keitel wrote:
> Hi,
> 
> as of kernel 2.6.34 I sometimes get a strange hang during suspend to
> RAM. After echo mem > /sys/power/state, the suspend script hangs, Xorg
> eats 100% CPU, and the desktop is frozen. I can kill the script and the
> computer will then suspend and resume fine. The kernel log shows
> nothing interesting when the hang happens:
> 
> usblp0: removed
> usbcore: deregistering interface driver dvb_usb_vp7045
> dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II)
> successfully deinitialized and disconnected.
> PM: Syncing filesystems ... done.
> 
> Is this a known problem?

No, it's not.

> I had rock stable suspend with 2.3.33.x. The
> computer is a Mac mini Core2 Duo with i945 graphics. I use KMS. I will
> compile a kernel with suspend debug to get more information if the hang
> happens next time.

Yes,  please try to get more information.

Rafael
