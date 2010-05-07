Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab0EGNTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 09:19:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53253 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0EGNS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 09:18:59 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-kernel@vger.kernel.org
Subject: Driver for a SmartCard interface on a SoC
Date: Fri, 7 May 2010 15:18:50 +0200
User-Agent: KMail/1.9.9
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jiri Slaby <jslaby@suse.cz>,
       Alan Cox <alan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005071518.50406.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

most SmartCard readers are external devices, connected via USB or serial 
lines. So, they do not need special in-kernel drivers.

My SmartCard interface is part of a SoC (i.MX25 CPU). So, I need an in-kernel 
driver. Where would be the best place in the kernel tree, to add a driver for 
this kind of device? Maybe "drivers/char"?
To exchange data with the plugged in SmartCard, only a couple of IOCTLs are 
required (detecting if a card is plugged in, socket power on/off, send reset 
to the card, configuring the communication parameters). Data exchange with 
the SmartCard can be done with simple read/write.

Any idea?

Regards,
Juergen
-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | Phone: +49-8766-939 228     |
Vertretung Sued/Muenchen, Germany             | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686              | http://www.pengutronix.de/  |
