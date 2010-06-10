Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab0FJVPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 17:15:09 -0400
Received: from mail.tmr.com ([64.65.253.246]:44983 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab0FJVPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 17:15:07 -0400
Message-ID: <4C1155B0.7030605@tmr.com>
Date: Thu, 10 Jun 2010 17:14:24 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Tino Keitel <tino.keitel+xorg@tikei.de>,
       intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: Suspend hangs since 2.6.34
References: <20100609175356.GA17332@x61.home> <201006100142.13131.rjw@sisk.pl> <4C108091.3060204@msgid.tls.msk.ru>
In-Reply-To: <4C108091.3060204@msgid.tls.msk.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> 10.06.2010 03:42, Rafael J. Wysocki пишет:
>> On Wednesday, June 09, 2010, Tino Keitel wrote:
>>> Hi,
>>>
>>> as of kernel 2.6.34 I sometimes get a strange hang during suspend to
>>> RAM. After echo mem>  /sys/power/state, the suspend script hangs, Xorg
>>> eats 100% CPU, and the desktop is frozen. I can kill the script and the
>>> computer will then suspend and resume fine. The kernel log shows
>>> nothing interesting when the hang happens:
>>>
>>> usblp0: removed
>>> usbcore: deregistering interface driver dvb_usb_vp7045
>>> dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II)
>>> successfully deinitialized and disconnected.
>>> PM: Syncing filesystems ... done.
> 
> Sounds very much like the problem I have with 2.6.34 final.  Did not
> happen with 2.6.34-rc7 which suspended just fine, but happens quite
> regularly on 2.6.34 final - not every suspend but each 2nd or 3rd
> attempt.  I stopped doing suspend-to-ram due to this, because it's
> unreliable.  Suspend-to-disk works just fine.
> 
>>> Is this a known problem?
>>
There are two things you can try if you wish, one is to go the text console 
before suspend, the other is to run your system in VESA video mode (assuming you 
are a lucky person and any other mode is supported).

I'm not running on 2.6.34 for production (2.6.33.5) but I did try when it first 
came out, and saw some issues there.

>> No, it's not.
>>
>>> I had rock stable suspend with 2.3.33.x. The
>>> computer is a Mac mini Core2 Duo with i945 graphics. I use KMS. I will
>>> compile a kernel with suspend debug to get more information if the hang
>>> happens next time.
> 
> It's amd780g athlon-based machine here, with radeon graphics, also with 
> KMS.
> 
>> Yes,  please try to get more information.
> 
> Got it ;)
> 
> /mjt


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

