Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab2IWPgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 11:36:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52398 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab2IWPgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 11:36:50 -0400
Message-ID: <505F2C8E.9080607@gmail.com>
Date: Sun, 23 Sep 2012 10:36:46 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Maxin B. John" <maxin.john@gmail.com>
CC: Peter Korsgaard <jacmet@sunsite.dk>,
        "Jean Delvare (PC drivers,core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2] i2c: busses: i2c-ocores: Fix documentation filename
References: <20120923133012.GA22830@linux-3ix0.site>
In-Reply-To: <20120923133012.GA22830@linux-3ix0.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2012 08:30 AM, Maxin B. John wrote:
> Fixes the wrong filename.
> 
> Signed-off-by: Maxin B. John <maxin.john@gmail.com>
> ---

Acked-by: Rob Herring <rob.herring@calxeda.com>

> diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
> index bffd550..e39c122 100644
> --- a/drivers/i2c/busses/i2c-ocores.c
> +++ b/drivers/i2c/busses/i2c-ocores.c
> @@ -11,7 +11,7 @@
>  
>  /*
>   * This driver can be used from the device tree, see
> - *     Documentation/devicetree/bindings/i2c/ocore-i2c.txt
> + *     Documentation/devicetree/bindings/i2c/i2c-ocores.txt
>   */
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> 
