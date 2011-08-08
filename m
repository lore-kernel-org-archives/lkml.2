Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1HHL5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 07:57:11 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:41560 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab1HHL5J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 07:57:09 -0400
MIME-Version: 1.0
In-Reply-To: <201107230012.p6N0CZSM002466@hera.kernel.org>
References: <201107230012.p6N0CZSM002466@hera.kernel.org>
Date: Mon, 8 Aug 2011 13:57:08 +0200
X-Google-Sender-Auth: H74RIJYW1UJDvelb4WzRnp8Ao_Y
Message-ID: <CAMuHMdU0Cba9xFjfD6Fq1MqE5xZeDnsdN8qipmR6jQH9J6X4vQ@mail.gmail.com>
Subject: Re: b43: LCN-PHY add place for new PHY support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 02:12, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/1d738e64f3d957d56c1b51e64ebdef986a8760e3
> Commit:     1d738e64f3d957d56c1b51e64ebdef986a8760e3
> Parent:     0cd20a278e1ef9da9f6a987942794c9d65af8c4d
> Author:     Rafał Miłecki <zajec5@gmail.com>
> AuthorDate: Thu Jul 7 15:25:27 2011 +0200
> Committer:  John W. Linville <linville@tuxdriver.com>
> CommitDate: Fri Jul 8 11:11:25 2011 -0400

> diff --git a/drivers/net/wireless/b43/phy_lcn.h b/drivers/net/wireless/b43/phy_lcn.h
> new file mode 100644
> index 0000000..c046c2a
> --- /dev/null
> +++ b/drivers/net/wireless/b43/phy_lcn.h

> \ No newline at end of file

Woops...

gcc/cpp also complains:

drivers/net/wireless/b43/phy_lcn.h:14:28: warning: no newline at end of file

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
