Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0JQIC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 04:02:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41001 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab0JQIC1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 04:02:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ryexEwlSU+wgIpey58VzFvphvN/enwUw4mFDqeGHtCVv1G9p9s9gA2xzgO8EZ7Aa21
         6o5iprCjOYO9Kx57JAUp4dNyqqAzaoYq2PwHCMWvRnvWhghT11jngn5Np3F4QwMfSlek
         qGqVBTbZ1HTzRDnHAzjl27jeLnASojAyUrj7A=
MIME-Version: 1.0
In-Reply-To: <20101016151442.a21769f6.rdunlap@xenotime.net>
References: <alpine.DEB.2.00.1010161656590.12912@ayla.of.borg>
	<alpine.DEB.2.00.1010161722120.30415@ayla.of.borg>
	<20101016151442.a21769f6.rdunlap@xenotime.net>
Date: Sun, 17 Oct 2010 10:02:25 +0200
X-Google-Sender-Auth: QDHj3JLi_qeecPfWMalkjZ-jcjs
Message-ID: <AANLkTinLBfAqRtd22MJtN+-LYsfvPSnRWcS97iM2PGJy@mail.gmail.com>
Subject: Re: Build regressions/improvements in v2.6.36-rc8
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 00:14, Randy Dunlap <rdunlap@xenotime.net> wrote:
> BTW, do you use LC_ALL=C when doing builds?  I'd like to be able to read
> messages like this one:
>
> src/Documentation/spi/spidev_test.c:56: warning: (near initialization for â€˜trâ€™): 1 warnings in 1 logs

I just grab the logs from the linux-next build service.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
