Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab1DMIQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:16:48 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:53573 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab1DMIQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:16:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19877.23529.745123.819112@pilspetsen.it.uu.se>
Date: Wed, 13 Apr 2011 10:16:41 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.39-rc[1-3] fail to boot on G5 PowerMac
In-Reply-To: <1302652502.28876.76.camel@pasglop>
References: <19876.35918.322649.256455@pilspetsen.it.uu.se>
	<1302646173.28876.53.camel@pasglop>
	<1302652502.28876.76.camel@pasglop>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt writes:
 > 
 > > > Finally I tried using g5_defconfig with 2.6.39-rc3.  First boot
 > > > it did get to /sbin/init, but udev init took much longer than
 > > > normal and threw errors.  After a warm reboot the same kernel
 > > > hung as usual, this time before framebuffer init.
 > > > 
 > > > 2.6.38 works just fine.
 > > 
 > > Hrm, that must be new, I remember testing something around -rc1 on a
 > > similar machine and it worked fine. I'll see if I can find something
 > > out.
 > 
 > Ok so on a PowerMac7,3 here (dual 2.5Ghz and mostly same HW or at least
 > very similar) I can't reproduce your problem with a g5_defconfig.
 > 
 > Your config doesn't work well for me (I don't do modules, I netboot),
 > but after adding a few things to it, it seems to work fine as well. I
 > added radeonfb and the radeon DRM (not KMS) and I added eventfd, timerfd
 > and input events.
 > 
 > So I'm afraid I'm going to need you to bisect that one to find out what
 > exact change caused the breakage for you.

Thanks for checking.  I'll try a bisect later today.

/Mikael
