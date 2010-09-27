Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab0I0NzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:55:20 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:28203 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab0I0NzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:55:19 -0400
Subject: Re: [PATCH v11 11/17] Add header file for mp device.
From: Ben Hutchings <bhutchings@solarflare.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, davem@davemloft.net, herbert@gondor.hengli.com.au,
        jdike@linux.intel.com
In-Reply-To: <924a3a20630b9b0b7f3c66633c792360bbcc790d.1285385607.git.xiaohui.xin@intel.com>
References: <1285388855-27410-1-git-send-email-xiaohui.xin@intel.com>
	 <924a3a20630b9b0b7f3c66633c792360bbcc790d.1285385607.git.xiaohui.xin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Mon, 27 Sep 2010 14:55:15 +0100
Message-ID: <1285595715.2263.12.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Sep 2010 13:55:18.0614 (UTC) FILETIME=[9E925760:01CB5E4B]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17668.005
X-TM-AS-Result: No--14.440500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-25 at 12:27 +0800, xiaohui.xin@intel.com wrote:
> From: Xin Xiaohui <xiaohui.xin@intel.com>
> 
> Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
> Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
> Reviewed-by: Jeff Dike <jdike@linux.intel.com>
> ---
>  include/linux/mpassthru.h |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/mpassthru.h
> 
> diff --git a/include/linux/mpassthru.h b/include/linux/mpassthru.h
> new file mode 100644
> index 0000000..ba8f320
> --- /dev/null
> +++ b/include/linux/mpassthru.h
> @@ -0,0 +1,25 @@
> +#ifndef __MPASSTHRU_H
> +#define __MPASSTHRU_H
> +
> +#include <linux/types.h>
> +#include <linux/if_ether.h>
> +
> +/* ioctl defines */
> +#define MPASSTHRU_BINDDEV      _IOW('M', 213, int)
> +#define MPASSTHRU_UNBINDDEV    _IO('M', 214)
[...]

You need to include <linux/ioctl.h> first!

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

