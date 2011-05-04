Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab1EDSP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:15:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41350 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab1EDSP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wCZsnhesO3LyFlM5nli0RWlz2lEulB7tfs0bRi8leQc66FFKXbuaz2MdZOp+/o0AYH
         KEhqxIHWGhYXcao/UxGrEFzuDWUFnf+8Wl22XmIDBaEDN+/yWxHjE71W4nj6/lc2ojs1
         uZKWGpc9qXV/SvfiwCdOHk/a+LkEZ04OBLtrY=
MIME-Version: 1.0
In-Reply-To: <1304087822-22853-1-git-send-email-mmarek@suse.cz>
References: <1304087822-22853-1-git-send-email-mmarek@suse.cz>
Date: Wed, 4 May 2011 20:15:55 +0200
X-Google-Sender-Auth: NPCol0_DQ5Av2IDPFLN4vHbpWUQ
Message-ID: <BANLkTimP=DQu4_fwxux=5d0w7YanuURw4Q@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Update KCONFIG entry
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 16:37, Michal Marek <mmarek@suse.cz> wrote:
> Roman Zippel hasn't been active for several years. Add myself as kconfig
> maintainer, but change the mode to "Odd Fixes" to not set expectations
> too high. Also, remove the patchwork link, since it is not used for
> kbuild/kconfig.
>
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Thanks for adding him to CREDITS!

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  CREDITS     |    4 ++++
>  MAINTAINERS |    5 ++---
>  2 files changed, 6 insertions(+), 3 deletions(-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
