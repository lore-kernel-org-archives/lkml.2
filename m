Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab1BFMew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:34:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43574 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1BFMeu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:34:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JvDFWMhKsHGiKLetLl7aXD0pWFoIeE9QK4FRb5Z5R0VlrAf+RU7idYyCM8Gwqxcn7J
         CzX5lzc2L044/dTNZyJB16DFf3vvmXF3IhDCOITWs0jbyPlizNo56CUV8F12N+IMau/L
         vQDeAMCULYVMEFU46Lbt0/7g/+GqKr2+IIe0c=
MIME-Version: 1.0
In-Reply-To: <201102061212.32528.thomas.schlichter@web.de>
References: <201011271437.38126.thomas.schlichter@web.de>
	<20101130061051.GD17114@linux-sh.org>
	<201102061202.09503.thomas.schlichter@web.de>
	<201102061212.32528.thomas.schlichter@web.de>
Date: Sun, 6 Feb 2011 13:34:48 +0100
X-Google-Sender-Auth: gVrGSX73CUoALOuehVS30ea_YUs
Message-ID: <AANLkTinQQM7GEsPPg7tA3B+mQWb_V8wySUiHWa7X_cGU@mail.gmail.com>
Subject: Re: [PATCH 2/3] Add ioremap_cache and ioremap_wc to all architectures
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Schlichter <thomas.schlichter@web.de>
Cc: Paul Mundt <lethal@linux-sh.org>, Michal Januszewski <spock@gentoo.org>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This really should go to linux-arch...

On Sun, Feb 6, 2011 at 12:12, Thomas Schlichter
<thomas.schlichter@web.de> wrote:
>
>

Oops, no inline patch. Well, people know they can find the attachment
on lkml ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
