Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab0H3O4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 10:56:51 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41734 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0H3O4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 10:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=xNezqwWjwwFD1+4rH4a9mX0FVICbrHlct26vpv7ocuY6cg15dHn1tar8g1tk3EkNm0
         ig/CoL1pbPDuwCY6TbNkQ6BeTXZjTo3n4dWJdej68xXZIwRMljc8psKQQma5jx9BzG/C
         1v7rqg11WSh3xEMIWHpDyB3ZC0LKP7BH9EwHg=
MIME-Version: 1.0
In-Reply-To: <201008301428.34979.arnd@arndb.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
 <201008301055.49600.arnd@arndb.de> <20100830115428.24e76ae5@lxorguk.ukuu.org.uk>
 <201008301428.34979.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 30 Aug 2010 10:56:28 -0400
Message-ID: <AANLkTi=F3xYJ5_umQTT9N7RqQBL04162RVEka5A9YgYN@mail.gmail.com>
Subject: Re: [PATCH 4/5] tty/hw: move hardware drivers to drivers/tty/hw
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 08:28, Arnd Bergmann wrote:
> On Monday 30 August 2010, Alan Cox wrote:
>> > My impression was that it should actually be converted into an hvc
>> > driver as a cleanup and moved to drivers/tty/hvc. It can probably
>> > get reduced to one third of its size if you do that.
>>
>> Not sure it makes sense - hvc seems the wrong abstraction.
>
> It seems to be very similar to hvc_tile.c in purpose, which is
> the most trivial driver we have. Why would that not work?
>
> Most of bfin_jtag_comm is about interfacing with the tty layer
> and providing a kernel thread to do the polling, which is exactly
> what hvc_console.c does.

i have no idea what "hvc" is, but my limited knowledge was that it was
for large powerpc servers, so i didnt bother looking at it too much.
i simply wanted a way to create a tty on top of the hardware channel.
if there is a framework that doesnt break this usage and lets me
simplify my driver, then either works for me.
-mike
