Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab0DKS7B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 14:59:01 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:40009 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab0DKS67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 14:58:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fg18QK2G/ogZTV5bGtC9q28H96v/MDZMeorBA2dk1B96+zIQLl42QT6NltASRFubha
         YzlgRbHkWIKXNtUJMy36ZkiJoJBF7JlKUoWbLhzDip1z2y2PDSMAQcGTxF1EJM6ZqPAY
         Olh7Mhn68FEbikCQ5e4P+Bul2/CaRNBbPPCfo=
MIME-Version: 1.0
In-Reply-To: <20100412185136.GA13171@x200>
References: <20100411164701.GA7558@elf.ucw.cz> <20100412185136.GA13171@x200>
Date: Sun, 11 Apr 2010 20:58:58 +0200
X-Google-Sender-Auth: 346e3ec56b442aaa
Message-ID: <g2v10f740e81004111158r4d4714a1w23b8521d5d595b29@mail.gmail.com>
Subject: Re: LOCALVERSION_AUTO considered harmful
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 20:51, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Sun, Apr 11, 2010 at 06:47:01PM +0200, Pavel Machek wrote:
>> @@ -99,6 +98,11 @@ config LOCALVERSION_AUTO
>>         appended after any matching localversion* files, and after the value
>>         set in CONFIG_LOCALVERSION.
>>
>> +       Unfortunately, such finegrained versioning will mean that you will
>> +       not be able to use modules for development; even "make modules"
>> +       will change module versions, making recompiled modules impossible
>> +       to insert into old kernel.
>
> That's conditional BS.
> Turn off CONFIG_MODVERSIONS already.

Yeah, I disabled it ages ago. Even then (before git, probably even
before bitkeeper)
I had hard times inserting modules...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
