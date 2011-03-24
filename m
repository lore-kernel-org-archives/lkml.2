Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab1CXWDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 18:03:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61862 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014Ab1CXWD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 18:03:28 -0400
MIME-Version: 1.0
In-Reply-To: <1300993967-30987-1-git-send-email-guenter.roeck@ericsson.com>
References: <1300993967-30987-1-git-send-email-guenter.roeck@ericsson.com>
Date: Thu, 24 Mar 2011 23:03:27 +0100
Message-ID: <AANLkTinR57o23D4X0d6GqbmORy+=vv2RjLvt_3HWz_26@mail.gmail.com>
Subject: Re: [PATCH] mfd: Select MFD_CORE if TPS6105X driver is configured
From: Linus Walleij <linus.walleij@linaro.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 8:12 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:

> The TPS61050/61052 driver uses MFD core code, yet does not specify the
> dependency in Kconfig. If it is the only MFD driver configured, compilation
> fails with
>
> ERROR: "mfd_add_devices" [drivers/mfd/tps6105x.ko] undefined!
> ERROR: "mfd_remove_devices" [drivers/mfd/tps6105x.ko] undefined!
>
> Fix the problem by adding "select MFD_CORE" to the respective Kconfig entry.
>
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Günter,
Linus Walleij
