Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab2GQSat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:30:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47259 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab2GQSar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:30:47 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYBBa8BZMeGK0kiXNysn_ErpyKhTtbK8yFxf+JyMSndFw@mail.gmail.com>
References: <1340836334-20427-1-git-send-email-stigge@antcom.de>
	<CACRpkdYBBa8BZMeGK0kiXNysn_ErpyKhTtbK8yFxf+JyMSndFw@mail.gmail.com>
Date: Tue, 17 Jul 2012 15:30:46 -0300
Message-ID: <CAAAP30FtFOQSJ8UvN6H+L6qwPyphi27L+mxi-3COu6RAJQTHcQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] gpio: of_get_named_gpio_flags() return
 -EPROBE_DEFER if GPIO not yet available
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Roland Stigge <stigge@antcom.de>, cjb@laptop.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 3:24 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Jun 28, 2012 at 12:32 AM, Roland Stigge <stigge@antcom.de> wrote:
>
>> of_get_named_gpio_flags() and of_get_named_gpio() return -EPROBE_DEFER if the
>> respective GPIO is not (yet) available. This is useful if driver's probe()
>> functions try to get a GPIO whose controller isn't probed yet. Thus, the driver
>> can be probed again later on.
>>
>> The function still returns -EINVAL on other errors (parse error or node doesn't
>> exist). This way, the case of an optional/intentionally missing GPIO is handled
>> appropriately.
>>
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>
> Patch applied, if all gpio stuff shall defer properly in v3.6 we need this
> so let's do some testing in -next!
>
> Would be nice to get some ACK besides my own...

You can add mine. I've been using this patch for quite some time now.

Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

> Yours,
> Linus Walleij
