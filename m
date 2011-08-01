Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1HAJxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:53:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55577 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab1HAJx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:53:26 -0400
Message-ID: <4E367776.1070008@ru.mvista.com>
Date: Mon, 01 Aug 2011 13:52:54 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@st.com>
CC: linus.walleij@linaro.org, pratyush.anand@st.com, rajeev-dlh.kumar@st.com,
        linux@arm.linux.org.uk, bhupesh.sharma@st.com, shiraz.hashim@st.com,
        vinod.koul@intel.com, linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 03/20] dmaengine/amba-pl08x: Rearrange inclusion of
 header files in ascending order
References: <cover.1312190881.git.viresh.kumar@st.com> <16f5abd9452832860f3a11fe1ddabde05fa3ae8c.1312190881.git.viresh.kumar@st.com>
In-Reply-To: <16f5abd9452832860f3a11fe1ddabde05fa3ae8c.1312190881.git.viresh.kumar@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01-08-2011 13:37, Viresh Kumar wrote:

> Header files included in driver are not present in alphabetical order. Rearrange
> them in alphabetical order.

> Signed-off-by: Viresh Kumar<viresh.kumar@st.com>
> ---
>   drivers/dma/amba-pl08x.c |   17 ++++++++---------
>   1 files changed, 8 insertions(+), 9 deletions(-)

> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> index 4c4a309..8e2056b 100644
> --- a/drivers/dma/amba-pl08x.c
> +++ b/drivers/dma/amba-pl08x.c
> @@ -74,19 +74,18 @@
>    * Global TODO:
>    * - Break out common code from arch/arm/mach-s3c64xx and share
>    */
> -#include<linux/device.h>
> -#include<linux/init.h>
> -#include<linux/module.h>
> -#include<linux/interrupt.h>
> -#include<linux/slab.h>
> -#include<linux/delay.h>
> -#include<linux/dmapool.h>
> -#include<linux/dmaengine.h>
>   #include<linux/amba/bus.h>
>   #include<linux/amba/pl08x.h>
>   #include<linux/debugfs.h>
> +#include<linux/delay.h>
> +#include<linux/device.h>
> +#include<linux/dmaengine.h>
> +#include<linux/dmapool.h>
> +#include<linux/init.h>
> +#include<linux/interrupt.h>
> +#include<linux/module.h>
>   #include<linux/seq_file.h>
> -
> +#include<linux/slab.h>

    Shouldn't there be emoty line here?

>   #include<asm/hardware/pl080.h>

WBR, Sergei
