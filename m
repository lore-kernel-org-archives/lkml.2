Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab0ICUIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 16:08:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35096 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab0ICUIk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 16:08:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NO7Jvc+ERiXpoIBwowNBRrNfiC0sLW73rRfK2EVfcfwOB9cQJFuxYcdTd6YeVpWWnf
         T3gSqNDCHRF22UffVDkZM86Gwmlch1PbNr9ImLbIybBqyyAULFeMo5CPD+y8wNfnpgRq
         UOe2xU3Cw2caiQhB3+YLZePDVUcPMBg2Ub+bI=
MIME-Version: 1.0
In-Reply-To: <201009031729.58102.arnd@arndb.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
	<20100830184737.GA21339@suse.de>
	<201008302333.22447.arnd@arndb.de>
	<201009031729.58102.arnd@arndb.de>
Date: Fri, 3 Sep 2010 22:08:38 +0200
X-Google-Sender-Auth: FK3g-IxqL0UzHzsLw3tsNJevtu8
Message-ID: <AANLkTimjaqakjEhNc0nVSzfNPSwYtjYXmmOsxuh+iMjC@mail.gmail.com>
Subject: Re: [RFC 0/5] tty: move stuff around
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 3, 2010 at 17:29, Arnd Bergmann <arnd@arndb.de> wrote:
> amiserial,nozomi,synclink,
> rocket,ipwireless
> cyclades,moxa,mxser,
> isicom,bfin_jtag_comm   -> drivers/tty/
>
> stallion,istallion,
> epca,specialix,ip2,
> riscom,serial167        -> drivers/staging/tty/*

I thought we wanted to keep serial167 alive as long as it builds?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
