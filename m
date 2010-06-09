Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab0FIRyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 13:54:06 -0400
Received: from eazy.amigager.de ([213.239.192.238]:34283 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658Ab0FIRyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 13:54:04 -0400
Date: Wed, 9 Jun 2010 19:53:56 +0200
From: Tino Keitel <tino.keitel+xorg@tikei.de>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Suspend hangs since 2.6.34
Message-ID: <20100609175356.GA17332@x61.home>
Mail-Followup-To: intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

as of kernel 2.6.34 I sometimes get a strange hang during suspend to
RAM. After echo mem > /sys/power/state, the suspend script hangs, Xorg
eats 100% CPU, and the desktop is frozen. I can kill the script and the
computer will then suspend and resume fine. The kernel log shows
nothing interesting when the hang happens:

usblp0: removed
usbcore: deregistering interface driver dvb_usb_vp7045
dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II)
successfully deinitialized and disconnected.
PM: Syncing filesystems ... done.

Is this a known problem? I had rock stable suspend with 2.3.33.x. The
computer is a Mac mini Core2 Duo with i945 graphics. I use KMS. I will
compile a kernel with suspend debug to get more information if the hang
happens next time.

Regards,
Tino
