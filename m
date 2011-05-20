Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab1ETGUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 02:20:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35054 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab1ETGUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 02:20:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OiD5ioQ+YMgKpBxB+nMNvqb90xWb2OcvZ5XdyTuh//fRnj+g/DkxkNVZtG6FjfY69I
         EPyj7SDclZkKoKNfuMlB3YQeb/BP1udVgo2pncCeclg9R8WUf1Jkk/IDbq0nIzJiOXnD
         TkqWkTAUamCTy3yJiLTA4OfFf6wuP+KS/GLTY=
MIME-Version: 1.0
In-Reply-To: <20110520061259.GA13483@p183>
References: <20110520061259.GA13483@p183>
Date: Fri, 20 May 2011 08:20:42 +0200
X-Google-Sender-Auth: VT42vZuAIfItkQe4zIMafx_VJps
Message-ID: <BANLkTi=2yReXfrr7swhys7TgkuJ5r97jqQ@mail.gmail.com>
Subject: Re: [PATCH] kstrtox: drop kstrtol()/kstrtoul() when possible
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        mmarek@suse.cz, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 08:15, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> If "long" and "long long" types are identical at runtime,
> kstrtol() can be aliased to kstrtoll().
>
> Unfortunately, one can't write
>
>        #if sizeof(long) == sizeof(long long) ...

One can write #ifdef CONFIG_64BIT instead.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
