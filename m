Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab2I1Cyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 22:54:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab2I1Cyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 22:54:41 -0400
Date: Thu, 27 Sep 2012 19:51:58 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 53/57] power: ab8500_fg: Moving structure definitions to
 header file
Message-ID: <20120928025158.GL5040@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-54-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-54-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:50AM -0600, mathieu.poirier@linaro.org wrote:
> From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>
> 
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
[...]
> diff --git a/drivers/power/ab8500_fg.h b/drivers/power/ab8500_fg.h
> new file mode 100644
> index 0000000..5cfadc2
> --- /dev/null
> +++ b/drivers/power/ab8500_fg.h
> @@ -0,0 +1,201 @@
> +/*
> + * Copyright (C) ST-Ericsson AB 2012
> + *
> + * Main and Back-up battery management driver.
> + *
> + * Note: Backup battery management is required in case of Li-Ion battery and not
> + * for capacitive battery. HREF boards have capacitive battery and hence backup
> + * battery management is not used and the supported code is available in this
> + * driver.
> + *
> + * License Terms: GNU General Public License v2
> + * Author: Johan Palsson <johan.palsson@stericsson.com>
> + * Author: Karl Komierowski <karl.komierowski@stericsson.com>
> + */
> +

The change is dubious, since you don't seem to use the header anywhere
outside of _fg, so technically there's no need for it.

But if you want to logically separate structs and definitions, it's fine.

OK, but at least you have to check for multiple inclusions, I guess.
I.e. #ifndef __AB8500_FG_H...

> +#define MILLI_TO_MICRO			1000
> +#define FG_LSB_IN_MA			1627
> +#define QLSB_NANO_AMP_HOURS_X10		1129
> +#define INS_CURR_TIMEOUT		(3 * HZ)
