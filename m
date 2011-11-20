Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab1KTUkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 15:40:13 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:46943 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab1KTUkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 15:40:11 -0500
Date: Sun, 20 Nov 2011 21:40:07 +0100
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111120204007.GA7273@nomi.cz>
References: <20111110125347.GA29415@nomi.cz> <20111110160703.GA2775@redhat.com> <20111110163051.GA24533@nomi.cz> <20111111054731.GA2292@redhat.com> <20111111150105.GA25437@nomi.cz> <20111114140714.GD2513@redhat.com> <20111119181106.GA5515@nomi.cz> <1321755233.22510.1.camel@wwguy-ubuntu> <20111120032016.GA14520@nomi.cz> <1321763314.22510.4.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1321763314.22510.4.camel@wwguy-ubuntu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Nov 19, 2011 at 08:28:34PM -0800, wwguy wrote:
> On Sat, 2011-11-19 at 19:20 -0800, Tomáš Janoušek wrote:
> > Anyway, did you have time to try to reproduce it with the .config I sent?
> > (It may take hours, sometimes. :-/)
>
> Yes, I will try your configuration when I get back  to the office Monday

Okay, thank you. I managed to test 2.6.38.8 and 2.6.39.4 today and the issue
is reproducible on both. Shall I test further in the past?

I also got a reply from the Ubuntu bugreport where someone claims he doesn't
experience the issue on current 32-bit Ubuntu 11.10, even though he did
experience it in older versions. I have no idea why that may be so, as they
have the same firmware as I have, and the kernel is 3.0 with almost no
modifications to the iwlagn driver.

I hope that you'll be able to reproduce the issue and fix it. Sadly, I still
haven't got a better reproducer. What I was doing today was running make clean
&& make -j4 in a while loop, having an active Skype videocall and browsing the
web while waiting for it to crash. Sometimes it took a few minutes, sometimes
more than an hour.

Regards,
-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
