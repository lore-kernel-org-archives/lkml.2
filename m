Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865Ab0HLTjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:39:25 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62450 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab0HLTjY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:39:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Z8PR3Bft+wO0MArRUl5bWPaFPvdf2+/4DeVCGcd1AMGwnmzPDp3lUXJlhIFdCn/CWi
         nn6ufl8kB/CPlsM4chsO3UHFsrv9DYECPvBcEWkpEvnlW5pZAGI3f8He2GESHg71j+pn
         5yG7xeUjZO/E3SG7o3V3bsZYrMXdFT8M5m484=
MIME-Version: 1.0
In-Reply-To: <201008101900.o7AJ0A2Z031557@hera.kernel.org>
References: <201008101900.o7AJ0A2Z031557@hera.kernel.org>
Date: Thu, 12 Aug 2010 21:39:23 +0200
X-Google-Sender-Auth: -QAzGQoMu0H9eUg1N5BXda6V4YE
Message-ID: <AANLkTinFTovdMBtMhzFF_mQWOHN9QdccbCnUBTFsC=Le@mail.gmail.com>
Subject: Re: fanotify: fscking all notification system
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Eric Paris <eparis@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 21:00, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/ff0b16a9850e8a240ad59e10b0a1291a8fcf7cbc

>    fanotify: fscking all notification system

> --- /dev/null
> +++ b/fs/notify/fanotify/Kconfig
> @@ -0,0 +1,11 @@
> +config FANOTIFY
> +       bool "Filesystem wide access notification"
> +       select FSNOTIFY
> +       default y
> +       ---help---
> +          Say Y here to enable fanotify suport.  fanotify is a file access
> +          notification system which differs from inotify in that it sends
> +          and open file descriptor to the userspace listener along with
             ^^^
             an
> +          the event.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
