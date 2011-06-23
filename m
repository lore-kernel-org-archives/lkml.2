Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142Ab1FWSES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:04:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60270 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933497Ab1FWSEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pjqGDiGrpI1CgxHa2HUZ33dneXDZP4VHf9FndkvAyUtOqsE8EiEKKeRCXZcbFlHcdh
         1yg2/cx0BAcLBTJGtU7NblV4xxwL8/lZoTkDQEu+95FNGrcyaFLUnYVtKURxXg2lC13H
         Axj5aFDVUwbvvqirZNJzWttuF70Neb5XaLCSc=
MIME-Version: 1.0
In-Reply-To: <cover.1308810463.git.joe@perches.com>
References: <cover.1308810463.git.joe@perches.com>
Date: Thu, 23 Jun 2011 20:04:13 +0200
X-Google-Sender-Auth: esCGVpoVWiWDrAmPZJBILua863E
Message-ID: <BANLkTinBoGpGEFmfDQ-JXAjFn-aRBSVEUw@mail.gmail.com>
Subject: Re: [PATCH 0/8] 8390: Neatening
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 08:38, Joe Perches <joe@perches.com> wrote:
> Some updates requested by Geert Uytterhoeven
>
> Joe Perches (8):
>  ariadne: Update style, neaten, restructure to eliminate prototypes
>  a2065: Use pr_fmt, pr_<level> and netdev_<level>
>  lib8390: Use pr_<level> and netdev_<level>
>  lib8390: Indent braces appropriately
>  lib8390: Normalize source code spacing
>  lib8390: Convert include <asm to include <linux
>  lib8390: Remove unnecessary extern
>  zorro8390: Restructure and eliminate prototypes

Looks good. I had to make some minor adjustments to make it apply to my
current tree, though.

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
