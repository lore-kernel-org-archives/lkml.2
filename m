Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab0HJPIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 11:08:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45510 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab0HJPIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 11:08:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=wZM+WKU60VD2be34Sv/JFLdBUgxosHVLd9HqLyLif4KmwogQbi/3iyCpg6oHkhTT+t
         uWHZWPuFTPczUbNejZizXjs/7bye1h21uvdQcYBQVH4vpWgq/Q6annbog99d2fmleTLa
         fyLeN2nHJW86wuocqNM/pwlcc1LLVpgHeg4NE=
MIME-Version: 1.0
Date: Tue, 10 Aug 2010 17:08:00 +0200
Message-ID: <AANLkTimGrTFF_PnUwEkb4_Tg0Ag0ocHuKSVGswYK1dzJ@mail.gmail.com>
Subject: USB device getting different product ids
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heya,

Admittedly I am using an older kernel, but I was wondering if a USB
device can get different product ids on being plugged in at different
times. I have one of these nice USB modems to connect to the internet
. It is one of these huawei devices. Now, most of the times, it gets
detected with vendor id 0x12d1 and product id 0x1446. In this mode, on
loading the usbserial module, I see only ttyUSB0 come up, which for
whatever reason, I am unable to use to connect to the internet.
However when it is detected as the product id 0x140b, I get
ttyUSB[0-2] which then connects very nicely via both wvdial and
networkmanager to the internet. Now obviously, I would like for the
device to get detected as 0x140b each time, as opposed to me pulling
it out and inserting it back in till does get detected as 0x140b :-).

So my question is,

1. Is it possible for the same device to get different product ids at
different times
2. If so, how do I possibly get it to detect the id I want, as opposed
to playing a game of chance.

I am currently using the Fedora 13 default kernel.

Thanks,
Dhaval

(I would copy linux-usb if I knew the mailing list id, but as I am on
a slow GPRS connection, which is quite flaky right now, I would like
to send this out right now. Please copy that list if it would help!)
