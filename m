Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab0ICUXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 16:23:07 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46695 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab0ICUXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 16:23:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Hs/jkZSo9BbkRsRylVuEyU/CqyDjGxrSCqAmA/Yi59MdscXn0w4hrUXXQkPZeuiD7e
         Gpnn+OiMn52b7JGjwwSeVkFEh2U95FQzT4U6tyFkK7H5V0q7X8Q4SHKnBd0K33aowoL+
         sV/A6y3lT7O9rE3A8wlRwPyV8u629z9AmklIE=
MIME-Version: 1.0
In-Reply-To: <20100903213203.54f69adc@lxorguk.ukuu.org.uk>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
	<20100830184737.GA21339@suse.de>
	<201008302333.22447.arnd@arndb.de>
	<201009031729.58102.arnd@arndb.de>
	<AANLkTimjaqakjEhNc0nVSzfNPSwYtjYXmmOsxuh+iMjC@mail.gmail.com>
	<20100903213203.54f69adc@lxorguk.ukuu.org.uk>
Date: Fri, 3 Sep 2010 22:23:02 +0200
X-Google-Sender-Auth: 2g5FE5gzEzpUawWyUZ-4vARbMCY
Message-ID: <AANLkTinOFjFv06pS5ZLyco88GAmJKQqbJVJ4C+p+cw82@mail.gmail.com>
Subject: Re: [RFC 0/5] tty: move stuff around
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@suse.de>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 3, 2010 at 22:32, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 3 Sep 2010 22:08:38 +0200
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
>> On Fri, Sep 3, 2010 at 17:29, Arnd Bergmann <arnd@arndb.de> wrote:
>> > amiserial,nozomi,synclink,
>> > rocket,ipwireless
>> > cyclades,moxa,mxser,
>> > isicom,bfin_jtag_comm   -> drivers/tty/
>> >
>> > stallion,istallion,
>> > epca,specialix,ip2,
>> > riscom,serial167        -> drivers/staging/tty/*
>>
>> I thought we wanted to keep serial167 alive as long as it builds?
>
> Does it build ? Is it secure ? I was under the impression the answer in
> both cases was no.

serial167 builds fine.
Your second question is more difficult to answer, though ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
