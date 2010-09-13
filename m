Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab0IMSMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:12:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38995 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab0IMSMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:12:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZBsbtZaqbTTmnyIYAtlE/svYL1K0gwV08jUtIVK9XH52Mlj/zhrkF3qMtcfRPyKi+k
         iBhQvXDF0JD6MFnX9QpnuoXQ/WSVB2r9AeDcusTqzEzSz1ntE+sua8/AqF3NbFoi6/qG
         oyfNZk45iEPIUtGkN4dU7z+MdwKN2+u8+TwE8=
MIME-Version: 1.0
In-Reply-To: <20100820211539.079080751@suse.com>
References: <20100820211401.651509182@suse.com>
	<20100820211539.079080751@suse.com>
Date: Mon, 13 Sep 2010 20:12:30 +0200
X-Google-Sender-Auth: vtt8pFqKK1SN8l7ovhFjnzXs6v8
Message-ID: <AANLkTinUzMQo76=sths9TjQqOp2Y_8BDuV00NF-=gWYM@mail.gmail.com>
Subject: Re: [patch 08/10] ioctl: Use asm-generic/ioctls.h on m68k (enables termiox)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 23:14, Jeff Mahoney <jeffm@suse.com> wrote:
> This patch converts m68k to use asm-generic/ioctls.h instead of its
> own version.
>
> The differences between the arch-specific version and the generic
> version are as follows:
>
> - m68k defines its own value for FIOQSIZE, asm-generic/ioctls.h keeps it
> - The generic version adds TIOCSRS485 and TIOCGRS485m which are unused
>  by any driver available on this architecture.
> - The generic version adds support for termiox
>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Roman Zippel <zippel@linux-m68k.org>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Applied

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
