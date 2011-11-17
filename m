Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab1KQJnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 04:43:16 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35832 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab1KQJnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:43:14 -0500
Message-ID: <4EC4D72F.8030702@evidence.eu.com>
Date: Thu, 17 Nov 2011 10:43:11 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Juergen Beisert <jbe@pengutronix.de>,
        Matthias Fuchs <mfuchs@ma-fu.de>
Subject: Re: [PATCH 5/8] serial: 8250: reject delaying RTS with RS485
References: <1321460685-15753-1-git-send-email-w.sang@pengutronix.de> <1321460685-15753-6-git-send-email-w.sang@pengutronix.de>
In-Reply-To: <1321460685-15753-6-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Il 16/11/2011 17:24, Wolfram Sang ha scritto:
> There might be chips capable of doing this, but for now nothing is implemented,
> so reject usage of this feature.

The delay must not necessarily be done by hardware. The drivers/tty/serial/crisv10.c 
driver, for example, delays through a msleep.

I don't know if having a software delay in this driver can make sense in some particular 
circumstance.

Best regards,

	Claudio
