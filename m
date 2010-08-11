Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab0HKT7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 15:59:06 -0400
Received: from borg.asidev.net ([95.141.32.69]:49297 "EHLO borg.asidev.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655Ab0HKT7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 15:59:04 -0400
Message-ID: <4C630101.50205@evidence.eu.com>
Date: Wed, 11 Aug 2010 21:58:57 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Wolfram Sang <w.sang@pengutronix.de>, Philippe De Muyter <phdm@macqel.be>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, hskinnemoen@atmel.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Rick Bronson <rick@efn.org>, John Nicholls <john@thinlinx.com>,
        Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
        Ryan Mallon <ryan@bluewatersys.com>, rmk@arm.linux.org.uk,
        Bernhard Roth <br@pwrnet.de>, Konrad Mattheis <mattheis@ukma.de>,
        Elektrolot <elektrolot@wp.pl>,
        =?UTF-8?B?UHJjaGFsIEppxZnDrQ==?= <jiri.prchal@aksignal.cz>,
        gregkh@suse.de, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Documentation about RS485 serial communications
References: <4BB053C4.7050700@evidence.eu.com>	<4BB10304.6090006@bluewatersys.com>	<4BB1BF49.2000609@evidence.eu.com>	<4BB252E3.3030703@bluewatersys.com>	<4BBD8C9D.3070401@evidence.eu.com>	<20100408111310.524f7354@lxorguk.ukuu.org.uk>	<4BBDD71D.1010700@evidence.eu.com>	<4BFD1FB6.8050405@atmel.com>	<4BFE2F38.8050200@evidence.eu.com>	<4BFE41FD.2080804@atmel.com>	<20100527102917.GB31253@pengutronix.de>	<4C626CBF.9020609@evidence.eu.com> <20100811083214.21d2919e.randy.dunlap@oracle.com>
In-Reply-To: <20100811083214.21d2919e.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Best regards,

	Claudio
