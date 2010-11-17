Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab0KQXkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:40:33 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64694 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab0KQXkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:40:32 -0500
MIME-Version: 1.0
In-Reply-To: <25482.1290031268@localhost>
References: <1289922400.1253.3.camel@yio.site> <20101116155717.6671e484@lxorguk.ukuu.org.uk>
 <AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com>
 <20101116171447.29336514@lxorguk.ukuu.org.uk> <AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
 <20101116195538.7fa66b97@lxorguk.ukuu.org.uk> <20101116213622.GA17824@tango.0pointer.de>
 <20101116225619.5fa7ef8b@lxorguk.ukuu.org.uk> <20101116231023.GB27594@tango.0pointer.de>
 <25482.1290031268@localhost>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 18 Nov 2010 00:40:16 +0100
Message-ID: <AANLkTimV_zKK-Ubw3vJkDUtrYvB+W06cRR7Nz2vam6fP@mail.gmail.com>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
To: Valdis.Kletnieks@vt.edu
Cc: Lennart Poettering <mzxreary@0pointer.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 23:01,  <Valdis.Kletnieks@vt.edu> wrote:
> On Wed, 17 Nov 2010 00:10:24 +0100, Lennart Poettering said:
>
>> When two users A and B are logged in, on tty1 resp. tty2, then as long
>> as tty1 is active user A should get access to the sound card, usb key,
>> .... As soon as we switch to tty2 user B should.
>
> So I change to tty1, plug in my 8G USB memory stick, and I have access to it.
> I start copying something big to it, and change to tty2 to do something else
> while the long copy happens...
>
> ... and my copy craps out because tty1 lost access to the USB.
>
> Brilliant.

Brilliant conclusion. If you have mounted it, you own it. But you can
not make your inactive session mount another new one. It's like this
since ages. Hint: try stuff before hitting reply too fast. :)

Kay
