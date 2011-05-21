Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1EURqE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 13:46:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33288 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab1EURqC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 13:46:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=U2m3gawYx6yHLYwYP4TcxqFqfoz72gs7sfVWZ0abYmktP4Wczt7tyLWyvHiOTNgEvD
         GVkujILn1+ImzuDnQng+3HNop/tn7LsFHWSR23+YxjxPiuu364awkh2WbHQ3mnrnSngy
         VJi7IwlcoHHU+nMo+R/7YM+QHUKqxDUzOwOMk=
MIME-Version: 1.0
In-Reply-To: <201105211910.26025.arnd@arndb.de>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
	<201105211910.26025.arnd@arndb.de>
Date: Sat, 21 May 2011 19:46:01 +0200
X-Google-Sender-Auth: p-EyqRf_MFf-JsaYD-9kz1PZIlo
Message-ID: <BANLkTiksqyoXW_WDt1orHgXyoFhd=5E1Sw@mail.gmail.com>
Subject: Re: [PATCH] arch/c6x: new architecture port for linux
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Salter <msalter@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 19:10, Arnd Bergmann <arnd@arndb.de> wrote:
> - Do not register static platform devices, they are deprecated.
>  For devices that are always there, use platform_device_create_simple.

platform_device_register_simple.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
