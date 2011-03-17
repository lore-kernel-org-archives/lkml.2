Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab1CQKwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:52:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53677 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab1CQKwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:52:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wmnDBrJIIyO/baedAvkDxz8+J6frxNbMcH1TZY+d4tbxMgKksKMO0ylHWshTEOMhXF
         FvPbMsm2voeQPc5UMU0S+lgMtlvB/VNWlr0nU5RDfFuK8PQF/MCVPvjjJ7pnMHL49xAn
         MoiJiv+qCf9Ke1ZTITtTqmOePj/ZaTJDKvzVQ=
MIME-Version: 1.0
In-Reply-To: <20110317104618.095f16ba@lxorguk.ukuu.org.uk>
References: <AANLkTi=+ckqwFUH-4U3hyj=FDM7oNtBO9TOPTT3MAwDC@mail.gmail.com>
	<20110317104618.095f16ba@lxorguk.ukuu.org.uk>
Date: Thu, 17 Mar 2011 11:52:12 +0100
X-Google-Sender-Auth: VFXGqeO1RQ4SsnlyCCb6ytOz8ok
Message-ID: <AANLkTimek6P--jzpPHVe=V8UUo9Qmm9AYL3CF5fLaW9O@mail.gmail.com>
Subject: Re: serial167 (was: Re: [RFC 0/5] tty: move stuff around)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@suse.de>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Thu, Mar 17, 2011 at 11:46, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> As serial167 is now in staging in Linus tree...
>>
>> It still builds in 2.6.38. What is unsecure about it? If nothing,
>> please move it back,
>> as the whole MVME167 platform is pretty useless without its console driver.
>
> It has no reference counting and it doesn't use tty_port objects.

[...]

Many thanks for your elaborate (and valid) explanation!
I'll let the VME users sort it out...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
