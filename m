Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab1LRS1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 13:27:40 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57293 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab1LRS1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 13:27:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAMVnO+mCHQtyO3xUQJqoPSbBnDB0Avr0EEVKpEF31GpyQS-snw@mail.gmail.com>
References: <1324232035-2717-1-git-send-email-frdrc66@gmail.com>
	<CAMVnO+mCHQtyO3xUQJqoPSbBnDB0Avr0EEVKpEF31GpyQS-snw@mail.gmail.com>
Date: Sun, 18 Dec 2011 19:27:37 +0100
Message-ID: <CAMVnO+=bwk5B-Ez-zot3xc9rdRoA79rRT8-4AW3vkjRd3S=A+w@mail.gmail.com>
Subject: Re: [PATCH] at25: DeviceTree support added
From: Frederic LAMBERT <frdrc66@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch cleaned and without line wrapped this time (Sorry for the extra
"Signed-off-by").
This driver is really useful for lots of devices, not only EEPROMs
(I'm using it with a nvSRAM from Cypres...), and the DTS support was
really missing.

Hoping it can be useful to other people,

Best regards,
Frederic

2011/12/18 Frederic LAMBERT <frdrc66@gmail.com>
>
> From: Frederic Lambert <frdrc66@gmail.com>
>
> Signed-off-by: Frederic Lambert <frdrc66@gmail.com>
> Signed-off-by: Frederic LAMBERT <frdrc66@gmail.com>
> ---
>  Documentation/devicetree/bindings/spi/spi-bus.txt |   19 ++++++
>  drivers/misc/eeprom/at25.c                        |   62 ++++++++++++++++----
>  2 files changed, 68 insertions(+), 13 deletions(-)
> ...
