Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1CQKAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:00:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55381 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab1CQKAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:00:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=S5hRTNO9yDI9FZyV0oF6gCJyhC747Qg74UKGEJ1Jt8xF+If9Iie2KiRPMsqEPWgpQG
         ezWvoC8T3ZgmkNax0hGvjsOn2WoWDNA97jR3qZKc7SbgMtYMB9i+5Tehuw3EVXRXr5NE
         p7jyrGM9dTZEYcmgCKLP3yE+OCCh+z++UKosg=
MIME-Version: 1.0
Date: Thu, 17 Mar 2011 10:59:59 +0100
X-Google-Sender-Auth: jxKP4ksCYW02APUDS_xHQXXFNBA
Message-ID: <AANLkTi=+ckqwFUH-4U3hyj=FDM7oNtBO9TOPTT3MAwDC@mail.gmail.com>
Subject: serial167 (was: Re: [RFC 0/5] tty: move stuff around)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@suse.de>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
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

As serial167 is now in staging in Linus tree...

It still builds in 2.6.38. What is unsecure about it? If nothing,
please move it back,
as the whole MVME167 platform is pretty useless without its console driver.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
