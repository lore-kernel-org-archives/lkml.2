Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab0JDTWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 15:22:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44319 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab0JDTWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 15:22:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uF1M5JXIMhQ8VDK6zmMBwzT8G3kTnsFqmygo/iuuWoUNtTDDS1GlHWHzO/nmlmOoUz
         LX10dBmjS1jfjwim+noPzzIPZ7B2yHoNfW0R9sU9RpCcnLrxtRQ1PGHNli/DQ1G/mwgU
         NsBPjGxGCsin5gmS9Z13w0A9pxGvkWdmNWPd4=
MIME-Version: 1.0
In-Reply-To: <1285838880-4977-13-git-send-email-namhyung@gmail.com>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
	<1285838880-4977-13-git-send-email-namhyung@gmail.com>
Date: Mon, 4 Oct 2010 21:22:33 +0200
X-Google-Sender-Auth: 9jH3NEjFTxcoXdayNMYF_pA5nQc
Message-ID: <AANLkTi=vvxTRPL0Nt2TaOA05ChBWg1KGBzgwx9joLOuF@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 12/24] ptrace: cleanup arch_ptrace() on m68k
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 11:27, Namhyung Kim <namhyung@gmail.com> wrote:
> Use new 'regno', 'datap' variables in order to remove duplicated
> expressions and unnecessary castings.
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Roman Zippel <zippel@linux-m68k.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
