Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab0EJLpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 07:45:46 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:55384 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab0EJLpp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 07:45:45 -0400
Date: Mon, 10 May 2010 13:45:39 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: peter.hicks@poggs.co.uk
Cc: linux-kernel@vger.kernel.org
Subject: RE: option.ko: ZTE MF636 support
Message-ID: <20100510114539.GB9319@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1273442132.12665.28.camel@angel>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Peter,

>> Similar symptoms are the long delay on opening of devices 0 and 2.
>> /dev/ttyUSB0: status port
>> /dev/ttyUSB2: modem port (not working)
>Does "echo > /dev/ttyUSB0" return immediately, and "echo > /dev/ttyUSB2"
>take around 15 seconds to return?
Indeed, that's exactly what's happening.

>> What has been your solution to get the ZTE working?
>I've blacklisted devices 0, 1 and 2 using the attached patch, taken
>against 2.6.34-rc6.  It should be quite straightforward to modify this
>for your device.
Ah. It seems that there's been quite some change in the code base of the
option driver. Using .33.3 here. No such thing as "blacklisting".

>Without the patch, I'm able to use wvdial against ttyUSB3 to dial up,
>but the device is unresponsive to anything apart from a PPP LCP
>disconnect.
For the olicard100 it's been port 2, dialling, pppd starting up, but lcp 
cfg req timeouts. At least with the olicard100 there's been no real dialup.
Conn endpoint has never been talking to the device..

Thanks alot for your hint. Previously I intended to wait for the .34 to
come out, but regarding the promising changes in option.c I will reconѕider this.
What are your overall xp with .34 so far? rc-7 is out, quite a rc count.. Maybe
the .34 is also levelling out these days.. :)

Cheers,

Nils

