Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0GQWKj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 18:10:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33381 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab0GQWKi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 18:10:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w2X0Sa7BDKUw8sVZP/AlSU9upqZYa/2vJp4YcaxouLXMbpj6ZzniSDkPPns77CqP0n
         ZxC44kBcT5uUGOALVCtdjeFkRWvmOxRujHQu+US9EWNaJys1DJ+DweZb+NTzBSdY+8fC
         SuzLCdVJEzxzFUcFK4cwswriz6+5PdwVBASYA=
MIME-Version: 1.0
In-Reply-To: <4C41A413.50205@promwad.com>
References: <1279365780-18462-1-git-send-email-triad@df.lth.se>
	<4C41A413.50205@promwad.com>
Date: Sun, 18 Jul 2010 00:10:27 +0200
Message-ID: <AANLkTimJU5-vDLi3ssctgOWl3T6LDgdMlmvkRrm4vh23@mail.gmail.com>
Subject: Re: [PATCH 1/2] MISC: driver for the character LCD found in ARM 
	refdesigns
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: ivan.kuten@promwad.com
Cc: Linus Walleij <triad@df.lth.se>,
        Viktar Palstsiuk <viktar.palstsiuk@promwad.com>, mattia.jona@gmail.com,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/17 Ivan Kuten <ivan.kuten@promwad.com>:

>  Hello Linus,
> Any chance to sync your efforts with lcd-linux project
> (http://lcd-linux.sourceforge.net/) ?

If the LCD-linux people make an attempt to go into the mainline, I
promise I will immediately migrate my driver out of drivers/misc
and out into drivers/lcd or wherever it'll end up.

I cannot drive it however, they seem to be using special
hardware I haven't got access to.

> They seems to have a support for HD44780 LCD controller.

That's not the tricky bit of this driver actually, though there
is sure code to be de-duplicated if LCD-linux is merged,
ARM have some special-purpose silicon to handle the
HD44780 e.g. to fire interrupts when the display responds
etc.

Yours,
Linus Walleij
