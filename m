Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1GVTjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:39:00 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:37261 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755197Ab1GVTi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:38:59 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EANnQKU5tgwKe/2dsb2JhbABTp0t4iHwCu0kOhjEEo08
Date: Fri, 22 Jul 2011 21:38:57 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] Generic Watchdog Timer Driver
Message-ID: <20110722193857.GU3834@infomag.iguana.be>
References: <20110711135056.GT29245@infomag.iguana.be> <20110711213145.GB5811@pengutronix.de> <20110722191847.GI31767@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722191847.GI31767@infomag.iguana.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

> Status update: I incorporated your comments and Lars-Peter Clausen's comments and
> created V4.  The changes since V3 are:
> * removed overdocumentation
> * removed MODULE_SUPPORTED_DEVICE and +MODULE_ALIAS_MISCDEV
> * removed return -ENOTTY after switch (cmd) because we have the default allready
> * s/sent/send/
> * I'd suggest to swap the logic here (branch taken on error)
> * no_llseek removal squashed into patch 1
> * provide getter/setter methods for driver specific data so that we can easily do the conversion towards the device driver model
> * removed parent because this would change when we will start using the device driver model

And:
* Changed CONFIG_WATCHDOG_CORE from tristate to bool
* Added Docbook documentation for include:linuw/watchdog.h

Todo:
* Fix watchdog_unregister_device so that it returns an error if /dev/watchdog is still open.

Kind regards,
Wim.

