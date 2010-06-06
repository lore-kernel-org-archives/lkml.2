Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933869Ab0FFLRw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 07:17:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57713 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab0FFLRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 07:17:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BRWiF/5bE+eKx2kd5lIGAXA6cHhnSlrkmFli6o5HN2w6YZi54f8rHoPO945BG4OE4Q
         99ucDtmXXAwd2ZwtjrKgczw6asWE/KFQGi4qEzdSGRYlS34Nal9nAJ9v7R1PCUeUiUXu
         Zp33UUc4JlvU/cLKYVt+QLdld6/eKfzt1DswE=
MIME-Version: 1.0
In-Reply-To: <201006052252.21168.arnd@arndb.de>
References: <201005241600.o4OG0QuA012887@hera.kernel.org>
	<AANLkTil7N3ZJclwotDQVt-8IYKudZ5mqPbyH906Cd4IJ@mail.gmail.com>
	<201006052252.21168.arnd@arndb.de>
Date: Sun, 6 Jun 2010 13:17:48 +0200
X-Google-Sender-Auth: ol5x6m4M1agAHORa2bmoNwPy-BA
Message-ID: <AANLkTil4itZpw4k1Jr93BiivFQvSv6_e09CAgiNiziUJ@mail.gmail.com>
Subject: Re: hp_sdc_rtc: fix broken ioctl conversion
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 5, 2010 at 22:52, Arnd Bergmann <arnd@arndb.de> wrote:
> Commit 55929332c92 "drivers: Push down BKL into various drivers"
> introduced a regression in hp_sdc_rtc, caused by a missing
> change of the .unlocked_ioctl pointer to the newly introduced
> function.
>
> On Saturday 05 June 2010, Geert Uytterhoeven wrote:
>> Something went wrong with this one:
>>
>> | drivers/input/misc/hp_sdc_rtc.c:681: warning: initialization from
>> incompatible pointer type
>> | drivers/input/misc/hp_sdc_rtc.c:665: warning:
>> ‘hp_sdc_rtc_unlocked_ioctl’ defined but not used
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
