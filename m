Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab0JPLfv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 07:35:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33322 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab0JPLft convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 07:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Vt+Zop507ucDDueWyVFYnMn3lf6Mhiqsf0IBlXA/eTRPtW8OqNUhFqkZjgpcbW5b7W
         R9xqZNCVecwDVAevdGY0aVla77YuuO5lcrIFrsM2Rm7Wh7J3RSCsUETWPOZp0mpW1vUF
         ajJ5xjUtVKZ/6Gk8QRHXffvItsqKnpVKy1i4o=
MIME-Version: 1.0
In-Reply-To: <m262x24j2y.fsf@igel.home>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
	<1287135981-17604-23-git-send-email-akinobu.mita@gmail.com>
	<201010151253.15653.arnd@arndb.de>
	<AANLkTi=cA=yf7NmPVKXaZdoTBYmwdmy_frk7b_feG-WG@mail.gmail.com>
	<m262x24j2y.fsf@igel.home>
Date: Sat, 16 Oct 2010 13:35:47 +0200
X-Google-Sender-Auth: vXst5GJtV3YSCgXGk3MylNU_yVw
Message-ID: <AANLkTimHYYLZHOxgco3jotD7ikVhaPh8FVcSqeZwtrVc@mail.gmail.com>
Subject: Re: [PATCH 22/22] bitops: remove minix bitops from asm/bitops.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Akinobu Mita <akinobu.mita@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 10:50, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>
>> Funny, m68k uses the little endian minix file system?
>>
>> Perhaps this was due to minix using the ext2 accessors? And ext2 being
>> switched from big to little endian ext2 on m68k, without anyone
>> noticing the impact
>> on minix?
>
> m68k has always used big-endian minixfs and the minix bitops were always
> independent of the ext2 ones.

Thanks for confirming!

Hence "[PATCH 21/22] m68k: convert minix bitops to use little endian
bitops" is not correct?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
