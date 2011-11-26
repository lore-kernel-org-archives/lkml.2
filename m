Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1KZIwM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 03:52:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38210 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1KZIwK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 03:52:10 -0500
MIME-Version: 1.0
In-Reply-To: <CANFwon20C9NC6GmWnwfSHcWOSFe-7fdt_QbCQQNhegieNeDUNA@mail.gmail.com>
References: <CANFwon20C9NC6GmWnwfSHcWOSFe-7fdt_QbCQQNhegieNeDUNA@mail.gmail.com>
Date: Sat, 26 Nov 2011 16:52:09 +0800
Message-ID: <CAM_iQpVzASSdfJ0aibkUgx7gjwb7RxLv-ngVuPg4NXJuN1DLHA@mail.gmail.com>
Subject: Re: [PATCH] fix build error of function iio_event_getfd
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Hui Zhu <teawater@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 4:07 PM, Hui Zhu <teawater@gmail.com> wrote:
> Got a build error:
>  CC [M]  drivers/staging/iio/industrialio-core.o
> /home/teawater/kernel2/linux/drivers/staging/iio/industrialio-core.c:
> In function ‘iio_event_getfd’:
> /home/teawater/kernel2/linux/drivers/staging/iio/industrialio-core.c:262:32:
> error: ‘ev_int’ undeclared (first use in this function)
> /home/teawater/kernel2/linux/drivers/staging/iio/industrialio-core.c:262:32:
> note: each undeclared identifier is reported only once for each
> function it appears in
> Not sure it is fixed or not.

It is fixed twice...

https://lkml.org/lkml/2011/11/25/52
https://lkml.org/lkml/2011/11/23/114
