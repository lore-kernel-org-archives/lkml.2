Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab0LTTrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 14:47:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61694 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999Ab0LTTrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 14:47:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [BISECTED] agp/intel: revert "Remove confusion of stolen entries not stolen memory"
Date: Mon, 20 Dec 2010 20:47:08 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6-next-20101220+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>
References: <201012201912.19051.arnd@arndb.de> <849307$arcbdv@azsmga001.ch.intel.com>
In-Reply-To: <849307$arcbdv@azsmga001.ch.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012202047.08544.arnd@arndb.de>
X-Provags-ID: V02:K0:2l6tm6V6A9lyT9PVk46XIsx4b5buuEHDb38T1zmqz1G
 pnhNWJuRc8cJcgUPVFthAuqUNfPrG3/KjbqFIvJvAuDgpUlH1u
 O2Sq3/AtlImNtoMHr94nZGbIh9xzr7+qa0Jqmv3dtYX6+eLyq6
 Zi4ue7MKjN+IJ2c9mke5bR2OHY1Dr3mi0vwNIvRCupQMkFf+YV
 zCmj1ACVtbnw3J+zKV8Tg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 December 2010 19:53:35 Chris Wilson wrote:
> On Mon, 20 Dec 2010 19:12:19 +0100, Arnd Bergmann <arnd@arndb.de> wrote:
> > Commit c64f7ba5f10 "agp/intel: Remove confusion of stolen entries not stolen memory" caused a regression on my Intel G45 based system, using the VESA
> > Xorg driver or uvesafb. I have not tried if i915 with KMS shows the same
> > behaviour, but can try if necessary.
> 
> I'm very confused as to how this would have impacted the VESA video
> driver. Any clues as to what VESA is doing?

Not the slightest idea. I don't understand what your code is doing
either, I only bisected it in order to get a running linux-next
kernel.

> And what is the nature of the regression?

The machine is very much alive, but the screen output is garbled. On
the text console, it shows a couple of characters around the cursor
position all over the screen. In X, it seems to be similar. The kdm
login screen gets shown as a nice pattern of colours, and they
change when I move the mouse. I can't identify anything visible on the
screen though.

Trying with i915 KMS next.

	Arnd
