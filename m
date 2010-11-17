Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab0KQNCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:02:30 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35908 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab0KQNC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:02:29 -0500
MIME-Version: 1.0
In-Reply-To: <1289913494-21590-1-git-send-email-manjunatha_halli@ti.com>
References: <1289913494-21590-1-git-send-email-manjunatha_halli@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 17 Nov 2010 15:02:07 +0200
X-Google-Sender-Auth: OjPrTFVmcBfcWdi0R8EGUkRj0kw
Message-ID: <AANLkTi=ZT0E=A9ZYAM86qu4P8eStkF2PLep6-DofCX-s@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] FM V4L2 drivers for WL128x
To: manjunatha_halli@ti.com
Cc: mchehab@infradead.org, hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manjunatha,

On Tue, Nov 16, 2010 at 3:18 PM,  <manjunatha_halli@ti.com> wrote:
>  drivers/staging/ti-st/Kconfig        |   10 +
>  drivers/staging/ti-st/Makefile       |    2 +
>  drivers/staging/ti-st/fmdrv.h        |  259 ++++
>  drivers/staging/ti-st/fmdrv_common.c | 2141 ++++++++++++++++++++++++++++++++++
>  drivers/staging/ti-st/fmdrv_common.h |  458 ++++++++
>  drivers/staging/ti-st/fmdrv_rx.c     |  979 ++++++++++++++++
>  drivers/staging/ti-st/fmdrv_rx.h     |   59 +
>  drivers/staging/ti-st/fmdrv_tx.c     |  461 ++++++++
>  drivers/staging/ti-st/fmdrv_tx.h     |   37 +
>  drivers/staging/ti-st/fmdrv_v4l2.c   |  757 ++++++++++++
>  drivers/staging/ti-st/fmdrv_v4l2.h   |   32 +
>  11 files changed, 5195 insertions(+), 0 deletions(-)

Usually when a driver is added to staging, it should also have a TODO
file specifying what needs to be done before the driver can be taken
out of staging (at least as far as the author knows of today).

It helps keeping track of the open issues in the driver, which is good
for everyone - the author, the random contributor/observer, and
probably even the staging maintainer.

Can you please add such a TODO file ?

Thanks,
Ohad.

>  create mode 100644 drivers/staging/ti-st/fmdrv.h
>  create mode 100644 drivers/staging/ti-st/fmdrv_common.c
>  create mode 100644 drivers/staging/ti-st/fmdrv_common.h
>  create mode 100644 drivers/staging/ti-st/fmdrv_rx.c
>  create mode 100644 drivers/staging/ti-st/fmdrv_rx.h
>  create mode 100644 drivers/staging/ti-st/fmdrv_tx.c
>  create mode 100644 drivers/staging/ti-st/fmdrv_tx.h
>  create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.c
>  create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.h
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
