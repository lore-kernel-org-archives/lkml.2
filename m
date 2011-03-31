Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab1CaGQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:16:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56513 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1CaGQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:16:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZwQi4f6WDIhmKGSlo8dSB62idlcYg1jvs62bVC8g2kCnKXrSvEOyA4176ql1/zaIlk
         hhsD6uPisUgoNLvrK4ptq52MFlaKFUn0Po1r0MEIG3gJTl7O+URyLTJi4aZocXfRxjwS
         wgU8VUIvrjWWZqqxhiVlseBtWwQ8DCyeacGmg=
MIME-Version: 1.0
In-Reply-To: <AANLkTimuDf+Qo0e_sVuNX5DavOBSu+Gr-VryeD9aSw_9@mail.gmail.com>
References: <1301050810-11329-1-git-send-email-akinobu.mita@gmail.com>
	<AANLkTikKA2MY6nf+LLyJbNQffX=qYY3eZdpNmwVQc21u@mail.gmail.com>
	<m2sju4jrov.fsf@igel.home>
	<AANLkTimuDf+Qo0e_sVuNX5DavOBSu+Gr-VryeD9aSw_9@mail.gmail.com>
Date: Thu, 31 Mar 2011 08:16:35 +0200
X-Google-Sender-Auth: EWWu3_xZrwWoxPlSCmccav6MFks
Message-ID: <AANLkTi=kamiujNVhVgjPLjyPnEw0gSgNn=28QVmsP-5j@mail.gmail.com>
Subject: Re: [PATCH] m68k: fix find_next bitops
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Roman Zippel <zippel@linux-m68k.org>,
        linux-m68k@vger.kernel.org,
        Michael Schmitz <schmitzmic@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 08:02, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 2011/3/31 Andreas Schwab <schwab@linux-m68k.org>:
>> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>>
>>> Andreas, do you think it's worth keeping (and fixing) the m68k "optimized"
>>> versions?
>>
>> Should be easy to add the required offset >= size checks.
>
> OK, I'll try to fix the optimized version.
> Or, could someone who can test on the real hardware fix this problem?

I'll have a look...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
