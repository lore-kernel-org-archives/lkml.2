Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab1BWUlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:41:11 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:65445 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131Ab1BWUlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:41:10 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOb/ZE1R8sEZ/2dsb2JhbACmIHS8Fw2FUQQ
Date: Wed, 23 Feb 2011 21:41:08 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RFC] [PATCH 0/10] Generic Watchdog Timer Driver
Message-ID: <20110223204108.GA6327@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

To reduce copying the same code over and over in each watchdog device driver, Alan Cox and myself constructed a new framework/API that consolidates the common watchdog timer driver functions.

This framework/API consists of the following patches:
part  1: Introduction of the WatchDog Timer Driver Core
part  2: Add the basic ioctl functionality
part  3: Add the WDIOC_KEEPALIVE ioctl
part  4: Add the WDIOC_SETOPTIONS ioctl
part  5: Add the WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
part  6: Add orphan control
part  7: Add the Magic Close feature
part  8: Add the nowayout feature
part  9: Add support for a miscdev parent device
part 10: Add support for extra ioctl calls

Note: I still need to add the minimum and maximum timeout parameters.
(That will become part 11).

Please provide feedback,
Kind regards,
Wim.

