Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab1GKNu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:50:59 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:19180 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757316Ab1GKNu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:50:58 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAFb9Gk5tg34q/2dsb2JhbABTpzl4iHy/dA6GLASjHQ
Date: Mon, 11 Jul 2011 15:50:56 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 0/11 v3] Generic Watchdog Timer Driver
Message-ID: <20110711135056.GT29245@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

To reduce copying the same code over and over in each watchdog device driver, Alan Cox and myself constructed a new framework/API that consolidates the common watchdog timer driver functions.
I incorporated the changes/feedback that I received from the second post.

This framework/API consists of the following patches:
part  1: Introduction of the WatchDog Timer Driver Core
part  2: Add the basic ioctl functionality
part  3: Add the WDIOC_KEEPALIVE ioctl
part  4: Add the WDIOC_SETOPTIONS ioctl
part  5: Add the WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
part  6: Add the Magic Close feature
part  7: Add the nowayout feature
part  8: Add support for a miscdev parent device
part  9: Add support for extra ioctl calls
part 10: Add the minimum and maximum timeout parameters.
part 11: Remove llseek

The code will also be added to linux-2.6-watchdog-next.

Changes since V2:
* all "flags" are unsigned
* timeout values are also unsigned
* removed unnececessary debugging
* clean-up comments
* the core will be in drivers/watchdog/ and not in drivers/watchdog/core/

Kind regards,
Wim.

