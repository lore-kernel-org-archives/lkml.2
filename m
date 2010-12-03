Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab0LCOJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:09:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:41488 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab0LCOJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:09:45 -0500
Message-ID: <4CF8FA1F.40404@infradead.org>
Date: Fri, 03 Dec 2010 12:09:35 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: manjunatha_halli@ti.com, Greg KH <greg@kroah.com>, hverkuil@xs4all.nl,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC v6 0/9] FM V4L2 drivers for WL128x
References: <1291380631-25993-1-git-send-email-manjunatha_halli@ti.com> <AANLkTi=0jRz8cfU5KmpsCcMVK3si1ZfeDqKg3HPNqXS+@mail.gmail.com>
In-Reply-To: <AANLkTi=0jRz8cfU5KmpsCcMVK3si1ZfeDqKg3HPNqXS+@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 03-12-2010 11:54, Ohad Ben-Cohen escreveu:
> On Fri, Dec 3, 2010 at 2:50 PM,  <manjunatha_halli@ti.com> wrote:
> ...
>> Can you please also stage this version? Since the files are becoming big
>> to be posted as patches?
> 
> You should really CC Greg for staging requests...

In this case, the driver requires a change at the V4L2 API. The better is to
send it to me, c/c Greg at the git pull request, for him to know that a new
staging driver will be added.

> 
>>
>> Thanks & Regards,
>> Manjunatha Halli
>>
>> Manjunatha Halli (9):
>>  include:linux: videodev2.h: FM Rx control class
>>  Documentation:DocBook:v4l: Update the controls.xml for TI FM driver
>>  drivers:staging: ti-st: fmdrv common header file
>>  drivers:staging: ti-st: fmdrv_v4l2 sources
>>  drivers:staging: ti-st: fmdrv_common sources
>>  drivers:staging: ti-st: FM driver RX sources
>>  drivers:staging: ti-st: FM driver TX sources
>>  drivers:staging: ti-st: Kconfig & Makefile change
>>  driver:staging:ti-st: Update TODO for FM V4L2 driver.
>>
>>  Documentation/DocBook/v4l/controls.xml |   12 +
>>  drivers/staging/ti-st/Kconfig          |   10 +
>>  drivers/staging/ti-st/Makefile         |    2 +
>>  drivers/staging/ti-st/TODO             |   10 +-
>>  drivers/staging/ti-st/fmdrv.h          |  239 ++++
>>  drivers/staging/ti-st/fmdrv_common.c   | 2003 ++++++++++++++++++++++++++++++++
>>  drivers/staging/ti-st/fmdrv_common.h   |  402 +++++++
>>  drivers/staging/ti-st/fmdrv_rx.c       |  902 ++++++++++++++
>>  drivers/staging/ti-st/fmdrv_rx.h       |   59 +
>>  drivers/staging/ti-st/fmdrv_tx.c       |  420 +++++++
>>  drivers/staging/ti-st/fmdrv_tx.h       |   37 +
>>  drivers/staging/ti-st/fmdrv_v4l2.c     |  720 ++++++++++++
>>  drivers/staging/ti-st/fmdrv_v4l2.h     |   32 +
>>  include/linux/videodev2.h              |    8 +
>>  14 files changed, 4855 insertions(+), 1 deletions(-)
>>  create mode 100644 drivers/staging/ti-st/fmdrv.h
>>  create mode 100644 drivers/staging/ti-st/fmdrv_common.c
>>  create mode 100644 drivers/staging/ti-st/fmdrv_common.h
>>  create mode 100644 drivers/staging/ti-st/fmdrv_rx.c
>>  create mode 100644 drivers/staging/ti-st/fmdrv_rx.h
>>  create mode 100644 drivers/staging/ti-st/fmdrv_tx.c
>>  create mode 100644 drivers/staging/ti-st/fmdrv_tx.h
>>  create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.c
>>  create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.h
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>

