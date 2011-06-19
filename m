Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1FSUT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 16:19:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53796 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab1FSUT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 16:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PCzCfufB9ZQsPPXUyxfbw+0cjowfnKea2vCrDCdtk072r/lHWsiP6ZPx/D6T+n3QQZ
         mqbqe0umXVSPW6MROzIWr/QeecKPiU93Cyr8+N/s8EgHWVRUe/Bv1mGhQJvP+d3mN+lo
         MR/KsDVJTIwyPWpEM8D8bfN2P8MgKlF4lSnsU=
MIME-Version: 1.0
In-Reply-To: <1308483825-6023-17-git-send-email-jonas@southpole.se>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
	<1308483825-6023-17-git-send-email-jonas@southpole.se>
Date: Sun, 19 Jun 2011 22:19:56 +0200
X-Google-Sender-Auth: gbl86bPf3FUk5n_R7tOoKs8ADwo
Message-ID: <BANLkTimst2MhOgXMwxnWkwqeJDFfZrGRRg@mail.gmail.com>
Subject: Re: [PATCH 16/19] OpenRISC: Headers
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 13:43, Jonas Bonn <jonas@southpole.se> wrote:
> + * now that there are no memory-mapped IO devices on any other bus than
> + * then the local Wishbone bus and that these devices are all native
      ^^^^
The "then" should be removed.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
