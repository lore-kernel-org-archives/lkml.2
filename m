Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab1LBMBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 07:01:43 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:57317 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab1LBMBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 07:01:42 -0500
Message-ID: <1322827296.2313.21.camel@x61.thuisdomein>
Subject: Re: [RFCv2 8/9] xshm: Makefile and Kconfig for M7400 Shared Memory
 Drivers
From: Paul Bolle <pebolle@tiscali.nl>
To: Sjur =?ISO-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        sjurbren@gmail.com
Date: Fri, 02 Dec 2011 13:01:36 +0100
In-Reply-To: <1322595550-6473-9-git-send-email-sjur.brandeland@stericsson.com>
References: <1322595550-6473-1-git-send-email-sjur.brandeland@stericsson.com>
	 <1322595550-6473-9-git-send-email-sjur.brandeland@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spotted some typos, see below.

On Tue, 2011-11-29 at 20:39 +0100, Sjur Brændeland wrote:
>[...]
> diff --git a/drivers/xshm/Kconfig b/drivers/xshm/Kconfig
> new file mode 100644
> index 0000000..bae0da2
> --- /dev/null
> +++ b/drivers/xshm/Kconfig
> @@ -0,0 +1,17 @@
> +# XSHM gets selected by whoever wants it.
> +config XSHM
> +	depends on CONFIG_C2C
> +	tristate
> +
> +config XSHM_CHR
> +	tristate "Character device for External Shared Memory (XSHM)"
> +	select XSHM
> +	default n
> +	---help---
> +	Say "Y" if you want to character device for External Shared

Perhaps "[...] to use a character device for the [...]"? 

> +	Memory (XSHM) IPC mechanism. XSHM is an IPC protocol used to
> +	talk to external device such as modem over a shared memory
> +	(e.g. Chip to Chip).
> +	Only say "M" here if you want to test XSHM and needs to load

s/needs/need/.

> +	and unload its module.
> +	If unsure say N.
>[...]


Paul Bolle

