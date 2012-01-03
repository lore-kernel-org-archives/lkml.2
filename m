Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab2ACS1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 13:27:10 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50156 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab2ACS1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 13:27:07 -0500
Date: Tue, 3 Jan 2012 12:27:00 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Rabin Vincent <rabin.vincent@stericsson.com>, Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        rtc-linux@googlegroups.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John Stultz <john.stultz@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "Antonio-M. Corbi Bellot" <antonio.corbi@ua.es>,
        Marco Santos <marco.santos@waynext.com>,
        Christophe Vu-Brugier <cvubrugier@yahoo.fr>
Subject: Re: [096/104] rtc: Disable the alarm in the hardware
Message-ID: <20120103182659.GI21256@elie.hsd1.il.comcast.net>
References: <20111207161246.GA10995@kroah.com>
 <20111207161222.676101253@clark.kroah.org>
 <20120103162720.GA22050@elie.hsd1.il.comcast.net>
 <20120103164258.GA26638@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103164258.GA26638@suse.de>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> Greg KH wrote:

>>> From: Rabin Vincent <rabin.vincent@stericsson.com>
>>>
>>> commit c0afabd3d553c521e003779c127143ffde55a16f upstream.
[...]
> Is it also reverted (or fixed), in Linus's tree as well?

I don't see any relevant commits, no.  Here's another relevant thread:

 http://thread.gmane.org/gmane.linux.kernel/1233322/focus=1234433

Rabin, what do you think?  Should c0afabd3 be reverted from mainline,
or is there another fix ready?

Thanks,
Jonathan
