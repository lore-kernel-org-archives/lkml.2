Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab0KRFyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 00:54:18 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48607 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab0KRFyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 00:54:17 -0500
MIME-Version: 1.0
X-Originating-IP: [192.163.20.232]
In-Reply-To: <AANLkTi=ZT0E=A9ZYAM86qu4P8eStkF2PLep6-DofCX-s@mail.gmail.com>
References: <1289913494-21590-1-git-send-email-manjunatha_halli@ti.com>
	<AANLkTi=ZT0E=A9ZYAM86qu4P8eStkF2PLep6-DofCX-s@mail.gmail.com>
Date: Thu, 18 Nov 2010 11:24:16 +0530
X-Google-Sender-Auth: 5o26c171t4Tm6uJ4bATDKTw8cTE
Message-ID: <AANLkTinyaZ07HBFNHNyR9eK6__QdZtG6O1gQX1F+YRB9@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] FM V4L2 drivers for WL128x
From: Pavan Savoy <pavan_savoy@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, mchehab@infradead.org,
        hverkuil@xs4all.nl
Cc: manjunatha_halli@ti.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans, Mauro, Ohad,

On Wed, Nov 17, 2010 at 6:32 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Hi Manjunatha,
>
> On Tue, Nov 16, 2010 at 3:18 PM,  <manjunatha_halli@ti.com> wrote:
>>  drivers/staging/ti-st/Kconfig        |   10 +
>>  drivers/staging/ti-st/Makefile       |    2 +
>>  drivers/staging/ti-st/fmdrv.h        |  259 ++++
>>  drivers/staging/ti-st/fmdrv_common.c | 2141 ++++++++++++++++++++++++++++++++++
>>  drivers/staging/ti-st/fmdrv_common.h |  458 ++++++++
>>  drivers/staging/ti-st/fmdrv_rx.c     |  979 ++++++++++++++++
>>  drivers/staging/ti-st/fmdrv_rx.h     |   59 +
>>  drivers/staging/ti-st/fmdrv_tx.c     |  461 ++++++++
>>  drivers/staging/ti-st/fmdrv_tx.h     |   37 +
>>  drivers/staging/ti-st/fmdrv_v4l2.c   |  757 ++++++++++++
>>  drivers/staging/ti-st/fmdrv_v4l2.h   |   32 +
>>  11 files changed, 5195 insertions(+), 0 deletions(-)
>
> Usually when a driver is added to staging, it should also have a TODO
> file specifying what needs to be done before the driver can be taken
> out of staging (at least as far as the author knows of today).
>
> It helps keeping track of the open issues in the driver, which is good
> for everyone - the author, the random contributor/observer, and
> probably even the staging maintainer.
>
> Can you please add such a TODO file ?
>
> Thanks,
> Ohad.

Thanks Ohad, for the comments, We do have an internal TODO.
In terms of functionality we have stuff like TX RDS which already has
few CIDs in the extended controls.
extend V4L2 for complete-scan, add in stop search during hw_seek .. etc...
But I just wanted to ask whether this is good enough to be staged.
Because as we begin to implement and add in the items in TODO - the
patch set will keep continuing to grow.

So Hans, Mauro, What do you think ?
It would be real helpful - if this can be staged, it is becoming
difficult to maintain for us.

Thanks,
Pavan

>>  create mode 100644 drivers/staging/ti-st/fmdrv.h
>>  create mode 100644 drivers/staging/ti-st/fmdrv_common.c
>>  create mode 100644 drivers/staging/ti-st/fmdrv_common.h
>>  create mode 100644 drivers/staging/ti-st/fmdrv_rx.c
>>  create mode 100644 drivers/staging/ti-st/fmdrv_rx.h
>>  create mode 100644 drivers/staging/ti-st/fmdrv_tx.c
>>  create mode 100644 drivers/staging/ti-st/fmdrv_tx.h
>>  create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.c
>>  create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.h
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
