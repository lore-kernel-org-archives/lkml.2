Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1KHQex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:34:53 -0500
Received: from ra.se.axis.com ([195.60.68.13]:36367 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab1KHQes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:34:48 -0500
Date: Tue, 8 Nov 2011 17:34:44 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mikael Starvik <starvik@axis.com>, Darron Black <darron@griffin.net>
Subject: Re: [PATCH] RS485: fix inconsistencies in the meaning of some
	variables
Message-ID: <20111108163444.GN26898@axis.com>
References: <4E492CFF.7040905@pwrnet.de> <20110822211832.GA8023@kroah.com> <4EB3A009.10502@evidence.eu.com> <4EB8F6B9.6010008@atmel.com> <4EB90902.4030200@evidence.eu.com> <4EB9447C.4050109@atmel.com> <4EB94EAA.2010603@evidence.eu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB94EAA.2010603@evidence.eu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 04:45:46PM +0100, Claudio Scordino wrote:
> Subject: RS485: fix inconsistencies in the meaning of some variables
> From: Claudio Scordino <claudio@evidence.eu.com>
> 
> The crisv10.c and the atmel_serial.c serial drivers intepret the fields of the
> serial_rs485 structure in a different way.
> In particular, crisv10.c uses SER_RS485_RTS_AFTER_SEND and
> SER_RS485_RTS_ON_SEND for the voltage of the RTS pin; atmel_serial.c, instead,
> uses these values to know if a delay must be set before and after sending.
> This patch makes the usage of these variables consistent across all drivers and
> fixes the Documentation as well.
> >From now on, SER_RS485_RTS_AFTER_SEND and SER_RS485_RTS_ON_SEND will be used to
> set the voltage of the RTS pin (as in the crisv10.c driver); the delay will be
> understood by looking only at the value of delay_rts_before_send and
> delay_rts_after_send.
> 
> Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
> Signed-off-by: Darron Black <darron@griffin.net>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
