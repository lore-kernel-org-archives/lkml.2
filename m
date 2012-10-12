Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2JLWlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 18:41:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2JLWlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 18:41:06 -0400
MIME-Version: 1.0
In-Reply-To: <30758.1349789445@warthog.procyon.org.uk>
References: <30758.1349789445@warthog.procyon.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 12 Oct 2012 23:40:44 +0100
X-Google-Sender-Auth: WYN7l8SjZl8VSyQmolxG3ZZPQ3M
Message-ID: <CACxGe6u51-er_U=FBaHzhAE2orZuq_B-MSwVVnCvoqZnEeHu7w@mail.gmail.com>
Subject: Re: [GIT PULL] Disintegrate UAPI for spi
To: David Howells <dhowells@redhat.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 2:30 PM, David Howells <dhowells@redhat.com> wrote:
> Can you merge the following branch into the spi tree please.

Do you want this merged into 3.7? If so, go ahead and push it directly
to Linus. I've not been able to do any maintainership stuff for the
last merge window or this one. Mark Brown has covered for me on SPI.

g.

> This is to complete part of the Userspace API (UAPI) disintegration for which
> the preparatory patches were pulled recently.  After these patches, userspace
> headers will be segregated into:
>
>         include/uapi/linux/.../foo.h
>
> for the userspace interface stuff, and:
>
>         include/linux/.../foo.h
>
> for the strictly kernel internal stuff.
>
> ---
> The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:
>
>   Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)
>
> are available in the git repository at:
>
>
>   git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-spi-20121009
>
> for you to fetch changes up to 7939d3c2a677b06cf111a1304710dd97892f3695:
>
>   UAPI: (Scripted) Disintegrate include/linux/spi (2012-10-09 09:49:03 +0100)
>
> ----------------------------------------------------------------
> UAPI Disintegration 2012-10-09
>
> ----------------------------------------------------------------
> David Howells (1):
>       UAPI: (Scripted) Disintegrate include/linux/spi
>
>  include/linux/spi/Kbuild              | 1 -
>  include/uapi/linux/spi/Kbuild         | 1 +
>  include/{ => uapi}/linux/spi/spidev.h | 0
>  3 files changed, 1 insertion(+), 1 deletion(-)
>  rename include/{ => uapi}/linux/spi/spidev.h (100%)
> .



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
