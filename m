Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935370Ab0KQTcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:32:18 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49171 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935075Ab0KQTcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:32:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KEoMNM/gCBeQ3cZ2uupAaB9sSWs5hdeZhaF0OY+z1ND+smZNZurNKwti1LOg75bvE9
         WVhEOB/cyq4FhgfV80Qm66GdDkXzddC/FTW/rtdi98zH4T7yDwWgOkPF+ZKguR7dvilR
         QotpIYNLwr7/K2KTAOw97m43jnM4f7lvqY41w=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1011172027440.14551@ayla.of.borg>
References: <alpine.DEB.2.00.1011172027440.14551@ayla.of.borg>
Date: Wed, 17 Nov 2010 20:32:15 +0100
X-Google-Sender-Auth: rug38AMhcNrkHtrxF8NwfVYqePQ
Message-ID: <AANLkTi=NTGOv+EF_y=__=+P1ud7vqjvoaELPNi6ZhqbE@mail.gmail.com>
Subject: Re: Build regressions/improvements in v2.6.37-rc2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Michael Ellerman <michael@ellerman.id.au>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 20:28, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Below is the list of build error/warning regressions/improvements in
> v2.6.37-rc2[1] compared to v2.6.36[2].

> Thanks to the linux-next team for providing the build service.
>
> [1] http://kisskb.ellerman.id.au/kisskb/head/3363/ (97 out of 108 configs)
> [2] http://kisskb.ellerman.id.au/kisskb/head/3461/ (75 out of 108 configs)

Would it be possible to make sure tagged versions are always built for
all 108 configs?
Currently the coverage depends on how soon Linus pushes a new commit.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
