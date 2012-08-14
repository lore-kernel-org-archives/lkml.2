Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab2HNIWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:22:05 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58007 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab2HNIWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:22:02 -0400
MIME-Version: 1.0
In-Reply-To: <1344527635-6163-7-git-send-email-lee.jones@linaro.org>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
	<1344527635-6163-7-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 10:22:01 +0200
Message-ID: <CACRpkdZ9sVEM08HkZWnVCLt9kZ2NX-Fk+Jy_AZ65P3vSWk_UGQ@mail.gmail.com>
Subject: Re: [PATCH 6/8] mfd: Use interrupt-parent as IRQ controller if
 specified in DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Samuel Ortiz <sameo@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:53 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Without this patch the default behaviour is to climb the Device
> Tree and use the first encountered interrupt controller. This
> does not take into account if a device node has specified to use
> a particular IRQ controller using the interrupt-parent property.
> This patch ensures that property is adhered to.
>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Mark & Rob may want to check this out too.

Yours,
Linus Walleij
