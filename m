Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158Ab0E0VyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:54:25 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:10450 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932535Ab0E0VyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:54:19 -0400
Message-ID: <4BFEEA08.70401@bluewatersys.com>
Date: Fri, 28 May 2010 09:54:16 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Robert Emanuele <rob@emanuele.us>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       linux-kernel@vger.kernel.org,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-i2c@vger.kernel.org
Subject: Re: Controlling Driver Load Order
References: <AANLkTikzDvWakd7JW3DzTHinjS3dAlqzPx6K8V2qMDG7@mail.gmail.com> <AANLkTinkY8JYh44UOEPflBUDyQ2wat_AKShRjA3HPxrf@mail.gmail.com> <20100526235246.GA31068@pengutronix.de> <AANLkTikj8yGSK5Ovud_k8f6jWloojqDJmQ_H6pD_IFgM@mail.gmail.com> <20100527041358.GA14070@pengutronix.de> <AANLkTilKUfcYsPqr5kXlONJQAFCaE8D8U9ltQybIzCPu@mail.gmail.com> <4BFEDF6D.3090100@bluewatersys.com> <20100527214209.GC5636@pengutronix.de>
In-Reply-To: <20100527214209.GC5636@pengutronix.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang wrote:
>> Looks like this has already been done:
>> http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg03056.html
> 
> Always ask which kernel is used, sigh...

Sorry? I didn't see a kernel version mentioned. I went looking because I
had though that i2c-gpio was already subsys_initcall.

>> There was a discussion a while back to make all of the embedded i2c
>> busses be subsys_initcall since i2c is often a system bus on embedded
> 
> Oh, where was that? Can't recall (but couldn't recall that I acked the i2c-gpio
> patch above as well ;))
> 

Moving the embedded i2c busses to subsys_initcall was discussed here:
http://lists.lm-sensors.org/pipermail/i2c/2008-June/004142.html. The
i2c_gpio bus got mentioned, which is why I thought it had already been
changed.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
