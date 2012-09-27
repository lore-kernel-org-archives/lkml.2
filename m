Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab2I0WSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 18:18:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36295 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2I0WS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:18:28 -0400
MIME-Version: 1.0
In-Reply-To: <1348674710-102885-1-git-send-email-richard@nod.at>
References: <1348674710-102885-1-git-send-email-richard@nod.at>
Date: Fri, 28 Sep 2012 00:18:26 +0200
Message-ID: <CAFLxGvw+As5-d-kVOFztZG-n9gLEn9_Aouvmk+VUtsnmmbA3UA@mail.gmail.com>
Subject: Re: UBI: Fastmap request for inclusion (v19)
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Heinz.Egger@linutronix.de,
        artem.bityutskiy@linux.intel.com, tim.bird@am.sony.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 5:51 PM, Richard Weinberger <richard@nod.at> wrote:
>  MAINTAINERS                 |    6 +
>  drivers/mtd/ubi/Kconfig     |   20 ++
>  drivers/mtd/ubi/Makefile    |    1 +
>  drivers/mtd/ubi/attach.c    |  386 +++++++++++++++++++---------
>  drivers/mtd/ubi/build.c     |   70 +++++-
>  drivers/mtd/ubi/eba.c       |  126 +++++++++-
>  drivers/mtd/ubi/ubi-media.h |  137 ++++++++++
>  drivers/mtd/ubi/ubi.h       |  118 +++++++++-
>  drivers/mtd/ubi/wl.c        |  599 ++++++++++++++++++++++++++++++++++++++-----
>  9 files changed, 1252 insertions(+), 211 deletions(-)

For what ever reason the diff stat misses fastmap.c
Here the correct one:

 MAINTAINERS                 |    6 +
 drivers/mtd/ubi/Kconfig     |   20 +
 drivers/mtd/ubi/Makefile    |    1 +
 drivers/mtd/ubi/attach.c    |  386 +++++++----
 drivers/mtd/ubi/build.c     |   70 ++-
 drivers/mtd/ubi/eba.c       |  126 ++++-
 drivers/mtd/ubi/fastmap.c   | 1560 +++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/ubi-media.h |  137 ++++
 drivers/mtd/ubi/ubi.h       |  118 ++++-
 drivers/mtd/ubi/wl.c        |  599 +++++++++++++++--
 10 files changed, 2812 insertions(+), 211 deletions(-)

> [PATCH 01/10] UBI: Add fastmap on-flash data structures
> [PATCH 02/10] UBI: Add fastmap stuff to ubi.h
> [PATCH 03/10] UBI: Export next_sqnum()
> [PATCH 04/10] UBI: Add self_check_eba()
> [PATCH 05/10] UBI: Add fastmap bits to build.c
> [PATCH 06/10] UBI: Wire-up ->fm_sem
> [PATCH 07/10] UBI: Add fastmap stuff to attach.c
> [PATCH 08/10] UBI: Add fastmap support to the WL sub-system
> [PATCH 09/10] UBI: Add fastmap core
> [PATCH 10/10] UBI: Wire-up fastmap

-- 
Thanks,
//richard
