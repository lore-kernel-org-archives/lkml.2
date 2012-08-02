Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab2HBMLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 08:11:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51472 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2HBMLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 08:11:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120802112542.6ae3dd8f@pyramind.ukuu.org.uk>
References: <1327999726-8774-1-git-send-email-sjur.brandeland@stericsson.com>
	<1327999726-8774-10-git-send-email-sjur.brandeland@stericsson.com>
	<20120802112542.6ae3dd8f@pyramind.ukuu.org.uk>
Date: Thu, 2 Aug 2012 14:11:05 +0200
Message-ID: <CAJK669YEbAq7xue9rAK9ikiUNm_ZVQZ4CaPhSr22xU56a_2B0g@mail.gmail.com>
Subject: Re: [RESEND PATCHv5 09/11] modem_shm: Character device for SHM
 channel access.
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Thu, Aug 2, 2012 at 12:25 PM,
>Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Add a character device implementation for the SHM stream channels.
>> The character device provides asynchronous IO and ring-buffer handling.
>> The device copies data directly from the Shared Memory area into
>> user-land buffers.
>
> What is the use case for this - it seems a little odd that it's not using
> the tty layer so won't work with all the normal modem apps as anyone
> would expect and want ?

Hi Alan,

Thank you for reviewing this patch.

I am working on a re-spin of the entire patch-set for Modem-SHM using
the RemoteProc framework from Ohad Ben Cohen and using Virtio as
transport mechanism between modem and host. I hope to be able to
use Virtio Console for the tty.The use-case tty/char device is for
transfering boot images to the modem and fetch crash logs.

For normal operation of the modem the CAIF protocol is used. I'm writing
on a new CAIF-Virtio driver for this that works with the RemoteProc
framework.

Regards,
Sjur
