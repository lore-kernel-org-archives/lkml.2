Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964990Ab2CFRt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 12:49:27 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:34131 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964866Ab2CFRt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 12:49:26 -0500
Message-ID: <4F565C04.1030202@ru.mvista.com>
Date: Tue, 06 Mar 2012 21:48:36 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH] pinctrl: include machine header to core.h
References: <1331038557-1398-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1331038557-1398-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03/06/2012 03:55 PM, Linus Walleij wrote:

> From: Linus Walleij<linus.walleij@linaro.org>

> struct pinctrl_setting contains an enum pinctrl_map_type
> field, so we need to include machine.h. Also fix kerneldoc
> to indicate that the pinctrl_setting is about both muxing
> and other config.

    I don't see where you touch kernel-doc...

> Signed-off-by: Linus Walleij<linus.walleij@linaro.org>
> ---
>   drivers/pinctrl/core.h |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)

> diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
> index 5b3ff13..42fb0ea 100644
> --- a/drivers/pinctrl/core.h
> +++ b/drivers/pinctrl/core.h
> @@ -12,6 +12,7 @@
>   #include<linux/mutex.h>
>   #include<linux/radix-tree.h>
>   #include<linux/pinctrl/pinconf.h>
> +#include<linux/pinctrl/machine.h>
>
>   struct pinctrl_gpio_range;

WBR, Sergei
