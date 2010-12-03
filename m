Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab0LCOBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:01:18 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:59498 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab0LCOBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:01:17 -0500
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Dec 2010 09:01:16 EST
MIME-Version: 1.0
In-Reply-To: <1291380631-25993-1-git-send-email-manjunatha_halli@ti.com>
References: <1291380631-25993-1-git-send-email-manjunatha_halli@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 3 Dec 2010 15:54:29 +0200
X-Google-Sender-Auth: ck_786DmW27F3AOE8gkObl2rKyY
Message-ID: <AANLkTi=0jRz8cfU5KmpsCcMVK3si1ZfeDqKg3HPNqXS+@mail.gmail.com>
Subject: Re: [RFC v6 0/9] FM V4L2 drivers for WL128x
To: manjunatha_halli@ti.com, Greg KH <greg@kroah.com>
Cc: mchehab@infradead.org, hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 3, 2010 at 2:50 PM,  <manjunatha_halli@ti.com> wrote:
...
> Can you please also stage this version? Since the files are becoming big
> to be posted as patches?

You should really CC Greg for staging requests...

>
> Thanks & Regards,
> Manjunatha Halli
>
> Manjunatha Halli (9):
>  include:linux: videodev2.h: FM Rx control class
>  Documentation:DocBook:v4l: Update the controls.xml for TI FM driver
>  drivers:staging: ti-st: fmdrv common header file
>  drivers:staging: ti-st: fmdrv_v4l2 sources
>  drivers:staging: ti-st: fmdrv_common sources
>  drivers:staging: ti-st: FM driver RX sources
>  drivers:staging: ti-st: FM driver TX sources
>  drivers:staging: ti-st: Kconfig & Makefile change
>  driver:staging:ti-st: Update TODO for FM V4L2 driver.
>
>  Documentation/DocBook/v4l/controls.xml |   12 +
>  drivers/staging/ti-st/Kconfig          |   10 +
>  drivers/staging/ti-st/Makefile         |    2 +
>  drivers/staging/ti-st/TODO             |   10 +-
>  drivers/staging/ti-st/fmdrv.h          |  239 ++++
>  drivers/staging/ti-st/fmdrv_common.c   | 2003 ++++++++++++++++++++++++++++++++
>  drivers/staging/ti-st/fmdrv_common.h   |  402 +++++++
>  drivers/staging/ti-st/fmdrv_rx.c       |  902 ++++++++++++++
>  drivers/staging/ti-st/fmdrv_rx.h       |   59 +
>  drivers/staging/ti-st/fmdrv_tx.c       |  420 +++++++
>  drivers/staging/ti-st/fmdrv_tx.h       |   37 +
>  drivers/staging/ti-st/fmdrv_v4l2.c     |  720 ++++++++++++
>  drivers/staging/ti-st/fmdrv_v4l2.h     |   32 +
>  include/linux/videodev2.h              |    8 +
>  14 files changed, 4855 insertions(+), 1 deletions(-)
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
