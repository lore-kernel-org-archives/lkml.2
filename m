Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab0E2OXN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 10:23:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60684 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab0E2OXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 10:23:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ecUxGsLWI/UFwkgAx+XldEUybOyDwcDwih+Vw2YwiQQtzHg5BpUpJItb7AAygppTTf
         plMvyEOKs/5rI9ccHnJpPI0ijcKn+H2+CTJA5fz/Jw0nIqPanOm0ZfgQPXc+EZ257mFi
         7n6nLCyGu4AY+XHI6Nob+cL0Wl1+1iwmFeIjo=
MIME-Version: 1.0
In-Reply-To: <4BF19A03.1060506@lougher.demon.co.uk>
References: <4BF19A03.1060506@lougher.demon.co.uk>
Date: Sat, 29 May 2010 16:23:06 +0200
X-Google-Sender-Auth: m9C37Lt23auw8WJONHeED6h7wDI
Message-ID: <AANLkTilk3j8yrvgykjY_UvteafFF4c2TMe3QTYiOV2_-@mail.gmail.com>
Subject: Re: [PATCH 4/4] squashfs: add xattr support configure option
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-fsdevel@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 21:33, Phillip Lougher
<phillip@lougher.demon.co.uk> wrote:
> +config SQUASHFS_XATTRS

Sorry for not noticing before, but all other file systems use "<fs>_XATTR", not
"<fs>_XATTRS". Just for consistency...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
