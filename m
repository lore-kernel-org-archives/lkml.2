Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab2LRKFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 05:05:36 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49904 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab2LRKFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 05:05:34 -0500
MIME-Version: 1.0
In-Reply-To: <20121218105223.0184d4a3@endymion.delvare>
References: <1355778259-8445-1-git-send-email-laurent.navet@gmail.com>
	<20121218105223.0184d4a3@endymion.delvare>
Date: Tue, 18 Dec 2012 11:05:33 +0100
Message-ID: <CAH7P7Nhz2FpBct4afvAXU2Zgi-yA4TkJj7CtYMaW7pXr6weZig@mail.gmail.com>
Subject: Re: [PATCH] driver i2c-nforce2: fix pointer CodingStyle issues
From: Laurent Navet <laurent.navet@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

> This is correct, however there are several other checkpatch errors and
> warnings in this file and I would appreciate if you could fix them as
> well. I'm not asking that you fix them all, but please consider fixing
> the following:
>
> WARNING: space prohibited between function name and open parenthesis '('
> #63: FILE: i2c/busses/i2c-nforce2.c:63:
> +MODULE_AUTHOR ("Hans-Frieder Vogt <hfvogt@gmx.net>");
>
> WARNING: suspect code indent for conditional statements (24, 33)
> #226: FILE: i2c/busses/i2c-nforce2.c:226:
> +			if (read_write == I2C_SMBUS_WRITE) {
> +				 outb_p(data->word, NVIDIA_SMB_DATA);
>
> WARNING: line over 80 characters
> #275: FILE: i2c/busses/i2c-nforce2.c:275:
> +			data->word = inb_p(NVIDIA_SMB_DATA) | (inb_p(NVIDIA_SMB_DATA+1) << 8);
>
> WARNING: quoted string split across lines
> #282: FILE: i2c/busses/i2c-nforce2.c:282:
> +				dev_err(&adap->dev, "Transaction failed "
> +					"(received block size: 0x%02x)\n",
>
> WARNING: space prohibited between function name and open parenthesis '('
> #330: FILE: i2c/busses/i2c-nforce2.c:330:
> +MODULE_DEVICE_TABLE (pci, nforce2_ids);
>
> WARNING: line over 80 characters
> #380: FILE: i2c/busses/i2c-nforce2.c:380:
> +	dev_info(&smbus->adapter.dev, "nForce2 SMBus adapter at %#x\n",
> smbus->base);
>
> ERROR: space required before the open parenthesis '('
> #395: FILE: i2c/busses/i2c-nforce2.c:395:
> +	switch(dev->device) {
>
> These are simple coding style issues, very easy to fix.

i have planned fixing these too, do you prefer one patch fixing all or
multiple patches (one per error/warning type )?

regards,
Laurent.
