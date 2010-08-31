Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab0HaPyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:54:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53941 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422Ab0HaPyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=H6j0PDZTTWWdD3mDiydFJpK+CnuItPE9ADUcpZ+QlyUvXiCUIfhYAvHBu7OgD7UnVN
         voK+90NhZQd4M3a7xP0u7x7ES0dI4DpD3CaSNBDSZjqD4E8tw3zFIF8z+iXjEcaNtkyZ
         2797gZetkpVrpTNTXJubFfwVZHJWZy9fuC5OE=
MIME-Version: 1.0
In-Reply-To: <201008311126.45190.arnd@arndb.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
 <201008302333.22447.arnd@arndb.de> <20100830232800.3cb768fc@lxorguk.ukuu.org.uk>
 <201008311126.45190.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 31 Aug 2010 11:53:50 -0400
Message-ID: <AANLkTimt43Rjxjat0rfJQDBzwzdH1pccpFa1QqBc62fk@mail.gmail.com>
Subject: Re: [RFC 0/5] tty: move stuff around
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roger Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 05:26, Arnd Bergmann wrote:
> On Tuesday 31 August 2010, Alan Cox wrote:
>> > bfin_jtag_comm          -> drivers/tty/hvc/hvc_bfin_jtag (?)
>>
>> Nothing to do with hvc
>
> Not yet ;-)
>
> You didn't reply to my question why it couldn't be. I'll let Mike
> judge this one when he has looked at the hvc infrastructure.
>
> I wouldn't move it to that directory unless the code gets changed
> first, but I wanted to write down where I think it should end up.

right ... as long as it isnt hvc, it should be .../tty/hw/.  when/if
it is converted to hvc, i'll also take care of moving it to the hvc/
subdir.

ive opened a tracker item for the issue, but no promise as to when
i'll look into it :p.
-mike
