Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab2IKNLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:11:21 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:59268 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab2IKNLT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:11:19 -0400
Date: Tue, 11 Sep 2012 15:11:05 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Nicolas Pitre <nico@fluxnic.net>,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bryan Wu <bryan.wu@canonical.com>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Richard Purdie <rpurdie@rpsys.net>, Dan Williams <djbw@fb.com>,
        Alan Stern <stern@rowland.harvard.edu>, Chris Ball <cjb@laptop.org>,
        David Woodhouse <dwmw2@infradead.org>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 14/16] ARM: orion: move platform_data definitions
Message-ID: <20120911151105.2178cde9@skate>
In-Reply-To: <1347368559-31329-2-git-send-email-arnd@arndb.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
	<1347368559-31329-1-git-send-email-arnd@arndb.de>
	<1347368559-31329-2-git-send-email-arnd@arndb.de>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

Le Tue, 11 Sep 2012 15:02:37 +0200,
Arnd Bergmann <arnd@arndb.de> a écrit :

> Platform data for device drivers should be defined in
> include/linux/platform_data/*.h, not in the architecture
> and platform specific directories.
> 
> This moves such data out of the orion include directories

I have already posted patches for this during the ARM summit, see:
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-August/116380.html.

They have been applied by the Marvell maintainer Jason Cooper and are
scheduled for 3.7, see
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-August/116432.html.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
