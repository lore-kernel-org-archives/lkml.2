Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab0HKUXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 16:23:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57028 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455Ab0HKUXy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 16:23:54 -0400
MIME-Version: 1.0
Message-ID: <77d8ceaa-53b7-4bd2-b3ca-cd825fb61ce8@default>
Date: Wed, 11 Aug 2010 13:20:37 -0700 (PDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: <claudio@evidence.eu.com>
Cc: <alan@lxorguk.ukuu.org.uk>, <jiri.prchal@aksignal.cz>, <rick@efn.org>,
        <akpm@linux-foundation.org>, <ryan@bluewatersys.com>,
        <w.sang@pengutronix.de>, <rmk@arm.linux.org.uk>,
        <nicolas.ferre@atmel.com>, <br@pwrnet.de>, <gregkh@suse.de>,
        <Sebastian.Heutling@who-ing.de>, <hskinnemoen@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <elektrolot@wp.pl>,
        <mattheis@ukma.de>, <linux-kernel@vger.kernel.org>,
        <john@thinlinx.com>, <phdm@macqel.be>
Subject: Re: [PATCH] Documentation about RS485 serial communications
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
From: claudio@evidence.eu.com
To: randy.dunlap@oracle.com
Sent: Wednesday, August 11, 2010 12:59:08 PM GMT -08:00 US/Canada Pacific
Subject: Re: [PATCH] Documentation about RS485 serial communications

Hi Randy,

	thank you for the feedback.

[...]

> 
> TIOC[SG]RS485 are #defined in <asm-generic/ioctls.h>, so
> #include <asm-generic/ioctls.h>
> here and/or below (in userspace program).
> 

I noticed that for some architectures (e.g., cris) these ioctls are defined also in arch/cris/include/asm/ioctls.h, and with different values with respect to the values defined on asm-generic/ioctls.h.

Therefore, I wasn't completely sure that the values defined in asm-generic are being used in every driver...
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Oh, OK, I see.  Thanks for the info.

~Randy
