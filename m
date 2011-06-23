Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198Ab1FWSLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:11:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62763 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235Ab1FWSLr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:11:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ptlaA8tQGHgJHUxgD/cJOWDSguxqwyRgOMpoRiZWW6hJrrl8P13iTtMIfkx/A2cCzC
         rFFBDjrg/RXQKcZV4ClWaYkhOHGZIp4YTZGKdc6deqtdRsErZrC7uyFoz7NOVDmn0mX9
         cVF3bHXa/4Jk7ji36K4gl3a74j7ZlLeFHb/5s=
MIME-Version: 1.0
In-Reply-To: <20110622190739.GB14351@albatros>
References: <20110622095341.GA3353@albatros>
	<1308760683.10423.16.camel@Joe-Laptop>
	<20110622191022.66135615@lxorguk.ukuu.org.uk>
	<20110622190739.GB14351@albatros>
Date: Thu, 23 Jun 2011 20:11:46 +0200
X-Google-Sender-Auth: poHhVI2ComExMTPD5-rAbvWz2sA
Message-ID: <BANLkTimQxzqstxLnO-_dDMoRbWbGPQJrvA@mail.gmail.com>
Subject: Re: [PATCH] kernel: escape non-ASCII and control characters in printk()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        security@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 21:07, Vasiliy Kulikov <segoon@openwall.com> wrote:
> On Wed, Jun 22, 2011 at 19:10 +0100, Alan Cox wrote:
>> If that is set you shouldn't be filtering out unicode, just control codes.
>
> OK.
>
>> Minor other nit is that you might want to allow BEL through and you
>> certainly want to allow tab through.
>
> In what situation do you think BEL makes sense in kernel log?  I cannot
> image the situation.  Alarms should use KERN_EMERG/KERN_ALERT log level.

Does BEL work? Last time I tried fancy things (e.g. color output
depending on the
message level), it didn't work. I only got strange characters.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
