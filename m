Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab0IVOWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 10:22:39 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:47311 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753025Ab0IVOWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 10:22:38 -0400
Message-ID: <4C9A111D.3080601@stericsson.com>
Date: Wed, 22 Sep 2010 16:22:21 +0200
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100914 Lightning/1.0b1 Thunderbird/3.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd: Declare abx500_remove_ops()
References: <1285163910-1789-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1285163910-1789-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Mark!
I'll update the abxxx-core drivers to call the remove_ops in their exit functions.

/Wallin

On 09/22/2010 03:58 PM, Mark Brown wrote:
> Otherwise sparse warns about a public symbol with no declaration and
> the compiler can't spot if the callers and users have different signatures
> for the function.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  include/linux/mfd/abx500.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
> index be7373c..67bd6f7 100644
> --- a/include/linux/mfd/abx500.h
> +++ b/include/linux/mfd/abx500.h
> @@ -229,4 +229,5 @@ struct abx500_ops {
>  };
>  
>  int abx500_register_ops(struct device *core_dev, struct abx500_ops *ops);
> +void abx500_remove_ops(struct device *dev);
>  #endif
