Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab2AFMbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 07:31:42 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48850 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab2AFMbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 07:31:41 -0500
MIME-Version: 1.0
In-Reply-To: <87ehw6sesk.fsf@rustcorp.com.au>
References: <87ehw6sesk.fsf@rustcorp.com.au>
Date: Fri, 6 Jan 2012 13:31:40 +0100
X-Google-Sender-Auth: 2-1JOPbkEOqkcRV4-aFR2p_ikGY
Message-ID: <CAMuHMdVYhVnxuvhThpeqcaazkSJQJBtrwrxwJc0=y_hV_7PsNg@mail.gmail.com>
Subject: Re: [PATCH 12/15] module_param: make bool parameters really bool
 (drivers & misc)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Thu, Dec 15, 2011 at 04:18, Rusty Russell <rusty@rustcorp.com.au> wrote:
> diff --git a/drivers/block/paride/bpck6.c b/drivers/block/paride/bpck6.c
> --- a/drivers/block/paride/bpck6.c
> +++ b/drivers/block/paride/bpck6.c
> @@ -21,7 +21,7 @@
>
>
>  /* PARAMETERS */
> -static int verbose; /* set this to 1 to see debugging messages and whatnot */
> +static bool verbose; /* set this to 1 to see debugging messages and whatnot */

"bool" doesn't exist at this point, cfr.

http://kisskb.ellerman.id.au/kisskb/buildresult/5325550/
http://kisskb.ellerman.id.au/kisskb/buildresult/5325257/

Any chance this is going to be fixed before it's sucked in Linus' tree?

Thanks in advance!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
