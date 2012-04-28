Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420Ab2D1Amv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 20:42:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:42748 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757979Ab2D1Amu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 20:42:50 -0400
Message-ID: <1335573757.20866.12.camel@pasglop>
Subject: Re: Regression in 32-bit ppc kernel
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 28 Apr 2012 10:42:37 +1000
In-Reply-To: <4F9B3398.9060701@lwfinger.net>
References: <4F973026.3020103@lwfinger.net>
	 <1335311621.15830.42.camel@pasglop> <4F976352.4060001@lwfinger.net>
	 <1335327081.21961.28.camel@pasglop> <4F98117C.7080309@lwfinger.net>
	 <1335390257.21961.53.camel@pasglop> <4F9ABD67.3060704@lwfinger.net>
	 <1335565573.20866.7.camel@pasglop> <4F9B3398.9060701@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 19:02 -0500, Larry Finger wrote:

> It is a 15" Powerbook G4. I think they call it a Titanium. The console is not on 
> a serial port. In fact, the reason that I did not think this patch was a problem 
> is because the serial port does not appear to be connected to an external port. 
> I was unaware that there was a serial port on the motherboard. There is a modem 
> jack, but no 9 or 25-pin connectors that would indicate a standard serial port.
> 
> There are two stack dumps with the same trace. I posted the first, but the 
> second is preceded by the lines
> 
> [<c02adca0] pmz_interrupt
> Disabling IRQ #23
> ttyPZ1: IrDA setup for 57600 bps, dongle version: 4
> ttyPZ1: IrDA setup for 115200 bps, dongle version: 4
> irq23: nobody cared (try booting with the "irqpoll" option
> 
> As I am not sure how to put options in with yaboot, I have not tried that.

Ok, so you do have a serial port, probably two even :-) One of them is
connected to the infra red transceiver and the other one is probably
connected to the internal modem.

(The modem itself might not use it, some of these machines use an
i2s/i2c modem, some use a usb modem, but the serial port is wired to the
connector regardless).

Cheers,
Ben.

