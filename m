Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569Ab0KPUPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:15:51 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57764 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759448Ab0KPUPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:15:48 -0500
MIME-Version: 1.0
In-Reply-To: <20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
References: <1289922400.1253.3.camel@yio.site> <20101116155717.6671e484@lxorguk.ukuu.org.uk>
 <AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com>
 <20101116171447.29336514@lxorguk.ukuu.org.uk> <AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
 <20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 16 Nov 2010 21:15:32 +0100
Message-ID: <AANLkTinXy3pNhwqo5aqHrH9fN99JhJrBtnbbpnq2h_K-@mail.gmail.com>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Lennart Poettering <lennart@poettering.net>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 20:55, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> we always will apply the final result just fine, when stuff stops
>> changing. It's actually a nice feature and no a problem at all, that
>> we only see the most recent state.
>
> Stuff never stops changing until the machine shuts down, its undefined.

Either you don't, or you just don't want to understand what all this
is about. :)

>> Sure, with the ioctl() we've seen many not interesting changes, but we
>> often miss the single one that is important -- the last last one. The
>> thing is that we don't need to sleep here and miss changes.
>
> So we fix the ioctl interface, it's not exactly hard to do now is it.
>
>> It's a straight-forward and simple text interface that does all we
>> need to track console and vt changes.
>
> Except that it doesn't address things like the permissions side of things.
>
> NAK again

Specifics please.

> "We have an interface that doesn't quite work for our case and we think
> that is a bug" is not the reasoning behind writing a new random one with
> a totally disconnected permission model that doesn't work either.
>
> Fix the one we have.

So how do you think you'll fix it? I better don't get into your
ioctl() business.

Kay
