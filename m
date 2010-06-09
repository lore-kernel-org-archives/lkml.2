Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab0FIIUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:20:36 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47140 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab0FIIUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=dTml5o5GPEKzuIC+xzasMs/JrL/SX3ipRpEdha8Hi5fvuknpw3UccUNd6w2KH7o1oz
         cKoTUk0X+frYUqmrWjIr+eDYXmLyWBLTBq8Vt+Y85BS6A9gro7lQiEX2JKi0MDpmfoee
         QYYblgc0B3XH77U/quBCqqiPmHsFzsxSFZXz8=
MIME-Version: 1.0
In-Reply-To: <AANLkTin_MR82jafZkkzfv33dO6DqyFnHUiU4g6luXB_0@mail.gmail.com>
References: <1275761686-4996-1-git-send-email-vapier@gentoo.org>
	<1276068030_13535@mail4.comsite.net>
	<AANLkTin_MR82jafZkkzfv33dO6DqyFnHUiU4g6luXB_0@mail.gmail.com>
Date: Wed, 9 Jun 2010 09:51:36 +0200
X-Google-Sender-Auth: RifdWySYsEXlW8t-sA6pCyP1978
Message-ID: <AANLkTimzODUP6tYXiagW7Kv3RVL6o8L_7dhF0DTf925x@mail.gmail.com>
Subject: Re: [PATCH 1/2] vmlinux.lds.h: allow people to set a smaller rootfs 
	alignment
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
       Tim Abbott <tabbott@ksplice.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 09:42, Mike Frysinger <vapier.adi@gmail.com> wrote:
> if we look at the alignments before the unification, we can easily see
> why Tim was a bit cautious and started the common value at PAGE_SIZE:

> m68k: 8192 (== 2x PAGE_SIZE?)

For Sun 3, PAGE_SIZE is 8192, not 4096. So it's the maximum page size on m68k.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
