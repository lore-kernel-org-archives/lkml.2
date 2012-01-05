Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341Ab2AEWD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 17:03:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab2AEWD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 17:03:28 -0500
Date: Fri, 6 Jan 2012 09:03:14 +1100
From: NeilBrown <neilb@suse.de>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: John Stultz <john.stultz@linaro.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sander Eikelenboom <linux@eikelenboom.it>, rjw@sisk.pl,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Regression: ONE CPU fails bootup at Re: [3.2.0-RC7] BUG: unable
 to handle kernel NULL pointer dereference at 0000000000000598  1.478005]
 IP: [<ffffffff8107a6c4>] queue_work_on+0x4/0x30
Message-ID: <20120106090314.2780d53a@notabene.brown>
In-Reply-To: <4F046C42.30903@canonical.com>
References: <1599287628.20120103171351@eikelenboom.it>
	<20120103190754.GA27651@phenom.dumpdata.com>
	<1325632188.3037.59.camel@work-vm>
	<20120104113155.27bf6e46@notabene.brown>
	<1325638380.3037.69.camel@work-vm>
	<20120104122040.5a0fa6a3@notabene.brown>
	<4F046C42.30903@canonical.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q05M3dlV022375

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Wed, 04 Jan 2012 16:12:02 +0100 Stefan Bader <stefan.bader@canonical.com>
wrote:


> Neil, this variation would also keep the kernel from crashing in my test
> environment. What do you think of that?

Hi Stefan,

That patch moves the call out of common code into device-specific code.
As my device doesn't have a 'cmos' rtc it wouldn't run at all for me.

I think we need to get __rtc_read_alarm() to return an error if the alarm time
is before the clock time.

Thanks,
NeilBrown

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwYeIjnsnt1WYoG5AQKZpw/9GAU05e5BPzZRF8ShqzEJyUUmYnHHQF7A
pZ2S1v7ihnWaEdK6bSdVfzwJpmdQOzNlJMjlLgh3BSZJRdHJtWKgPsZB46lyekYU
3j2KoBtXuzC5jY1HVLi8SMtwpPNJ3s4IcFTa2a5qhqfYCugzv7vWbxA/JTKpJtnB
2jYoBQyJ3W/dM4It2CXx/vouFUka/VtZ9AaMxCo+2c5LZaBXwgaodP9p6WQjyUTj
WASbNcIlUMEuI+fIYMh1SztWoBh4S0x8e7v1wIQluwCtb2zSEz9iIaf+oM1n/9jM
adMsrBhC6E+WZinijw/qTBWhLSR0uwfh16DLloqPh1BRq8PqLjXMt/zoAWgBh1uP
AKAZTYBzU4k8H0ies1F8Pc2LaX8b5py3I12Yk9u24F2G+RsF2GPJ3zUlnoD/YNaS
iBvoVbLlJLJ7l5OyoO1w6NnkWYzocXkV4K5NMdjABsbZATWuYZHMwgv+AAS2zXME
pffr6iyI4jI2TPFBRYIsbxIR0YjjqCVlwAGktVXAcYqppAO9itfwDtMKPTpmpvcd
rINnMbA4YGDEKo7htPAT5NiXZmGOIRvfAY2yd1dQdFlUhzGEA8uvYV8c1QScWqor
Gk0GThP5MSLJclg0kuWeRsVjeMKmKfzV+lcnw3Wx9s55RULff0HXM51Eyl4L+xtd
H8hLwRsN96I=
=UCTt
-----END PGP SIGNATURE-----
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
