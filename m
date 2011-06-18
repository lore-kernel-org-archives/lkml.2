Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab1FRMTk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 08:19:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59982 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab1FRMTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 08:19:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LsAh2zYImMxlCSH2uxME1gYu/NTv9dBZQQdBXtyAJ1XfnvKnx3crrxHIdeVB+I8ZtF
         G+3f1h3FKXNzFjxUnNOfFWZa/CYa74VA87faAIemp5MLrIacxsblgtno4MylxwWOT8Ry
         ut7e3t03on0mD91CbB9R9OP2H7EKcbVefaiew=
MIME-Version: 1.0
In-Reply-To: <20110618183029.822f4d82.sfr@canb.auug.org.au>
References: <alpine.DEB.2.00.1106151111200.18110@ayla.of.borg>
	<BANLkTikBDVR=S5J-=Kjq1QW3OU64WzHYRg@mail.gmail.com>
	<20110618183029.822f4d82.sfr@canb.auug.org.au>
Date: Sat, 18 Jun 2011 14:19:37 +0200
X-Google-Sender-Auth: gX-WzSj8inXlGaz96KHVq7a0FmI
Message-ID: <BANLkTinsa=Wh0_+YBzFRnp4M+FGejiANFw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.0-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Sat, Jun 18, 2011 at 10:30, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Wed, 15 Jun 2011 11:19:48 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> Would it be possible to build with `make -k', so it continues in case
>> of an error, and
>> tries to build as much as possible?
>> Yes, I know this may increase build time considerably, but in an ideal
>> world, there
>> are no compile errors and everything is built anyway ;-)
>
> Done (I think - it required very simple changes to a Python script and I

Thanks!

> only do "monkey see, monkey do" Python programming :-))

Good to know I'm not the only one ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
