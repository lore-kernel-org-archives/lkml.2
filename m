Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab1EXTjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:39:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60821 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1EXTjT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:39:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hCmH2pd1YTXc4GleCSd2n4y5b8X7ENtEBfoXOalyiUdn/68JPffm41U/51einqtAdT
         dgirpmKo1mDR2a3Qs9LOhxOIrUD3/Q3QfYDbYkx8ZKFcWYAmjEvClpY3ZTf+Yuy/x2iu
         wtQAn3HpKFHnasuRgzJFxgvPpykt6/blS/Fog=
MIME-Version: 1.0
In-Reply-To: <4DDBFC30.6030201@fusionio.com>
References: <4DDBF40E.7020003@fusionio.com>
	<BANLkTi=sYVpvEwShbhC65qfaA0Jt3rEjsQ@mail.gmail.com>
	<4DDBFC30.6030201@fusionio.com>
Date: Tue, 24 May 2011 21:39:17 +0200
X-Google-Sender-Auth: E0V2hnvfYntku0N-IwFTbqaXInE
Message-ID: <BANLkTi=xZmaMyzjcKv5_YiTavAvVRTPYiw@mail.gmail.com>
Subject: Re: [GIT PULL] Start of removal of legacy parallel interfaces for 3.0
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 20:42, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-05-24 20:37, Linus Torvalds wrote:
>> On Tue, May 24, 2011 at 11:08 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>> With the 3.0 kernel approaching, now is a great time to get rid of some
>>> legacy bagage. And what better part to start with than the old IDE code.
>>> Parallel interfaces are so 1990's, we can't be seen with those on a
>>> fancy new kernel version.

NAK.

>> No.
>>
>> Guys. Really.
>>
>> Any version numbering change is *not* an excuse to drop any old stuff,
>> or do anything new and exciting.
>
> Boy, you guys sure are humorless. I would've thought the reference to
> killing SCSI next would be a good clue.
>
> So we can't kill x86 32-bit either?

I wouldn't object to that one. Finally a good reason to kick admins
who still run
32-bit distros on 64-bit machines ;-)

Serious... Rumor says there's even a new 32-bit ABI for x86...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
