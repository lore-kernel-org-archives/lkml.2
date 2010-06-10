Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0FJGFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 02:05:09 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:60678 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab0FJGFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 02:05:07 -0400
Message-ID: <4C108091.3060204@msgid.tls.msk.ru>
Date: Thu, 10 Jun 2010 10:05:05 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Tino Keitel <tino.keitel+xorg@tikei.de>, intel-gfx@lists.freedesktop.org,
       linux-kernel@vger.kernel.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: Suspend hangs since 2.6.34
References: <20100609175356.GA17332@x61.home> <201006100142.13131.rjw@sisk.pl>
In-Reply-To: <201006100142.13131.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

10.06.2010 03:42, Rafael J. Wysocki пишет:
> On Wednesday, June 09, 2010, Tino Keitel wrote:
>> Hi,
>>
>> as of kernel 2.6.34 I sometimes get a strange hang during suspend to
>> RAM. After echo mem>  /sys/power/state, the suspend script hangs, Xorg
>> eats 100% CPU, and the desktop is frozen. I can kill the script and the
>> computer will then suspend and resume fine. The kernel log shows
>> nothing interesting when the hang happens:
>>
>> usblp0: removed
>> usbcore: deregistering interface driver dvb_usb_vp7045
>> dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II)
>> successfully deinitialized and disconnected.
>> PM: Syncing filesystems ... done.

Sounds very much like the problem I have with 2.6.34 final.  Did not
happen with 2.6.34-rc7 which suspended just fine, but happens quite
regularly on 2.6.34 final - not every suspend but each 2nd or 3rd
attempt.  I stopped doing suspend-to-ram due to this, because it's
unreliable.  Suspend-to-disk works just fine.

>> Is this a known problem?
>
> No, it's not.
>
>> I had rock stable suspend with 2.3.33.x. The
>> computer is a Mac mini Core2 Duo with i945 graphics. I use KMS. I will
>> compile a kernel with suspend debug to get more information if the hang
>> happens next time.

It's amd780g athlon-based machine here, with radeon graphics, also with KMS.

> Yes,  please try to get more information.

Got it ;)

/mjt
