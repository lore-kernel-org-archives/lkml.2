Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab0HTGxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 02:53:47 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:5458 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0HTGxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 02:53:42 -0400
Date: Fri, 20 Aug 2010 08:53:02 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Fenghua Yu" <fenghua.yu@intel.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Rudolf Marek" <r.marek@assembler.cz>,
        "Huaxu Wan" <huaxu.wan@intel.com>, "H Peter Anvin" <hpa@zytor.com>,
        "Guenter Roeck" <guenter.roeck@ericsson.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "lm-sensors" <lm-sensors@lm-sensors.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH] MAINTAINERS: hwmon/coretemp: Change coretemp
 maintainers
Message-ID: <20100820085302.5d29d2e3@hyperion.delvare>
In-Reply-To: <1282238896-23026-1-git-send-email-fenghua.yu@intel.com>
References: <1282238896-23026-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fenghua,

On Thu, 19 Aug 2010 10:28:16 -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Huaxu and Rudolf want me to be the hwmon coretemp driver maintainer and remove
> their names from the coretemp maintainer entry.

Thanks for stepping in! The coretemp driver definitely needs some
love.

> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> Acked-by: Rudolf Marek <r.marek@assembler.cz>
> Acked-by: Huaxu Wan <huaxu.wan@intel.com>
> ---
>  MAINTAINERS |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b5b8baa..ff0cd1e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1665,8 +1665,7 @@ F:	kernel/cgroup*
>  F:	mm/*cgroup*
>  
>  CORETEMP HARDWARE MONITORING DRIVER
> -M:	Rudolf Marek <r.marek@assembler.cz>
> -M:	Huaxu Wan <huaxu.wan@intel.com>
> +M:	Fenghua Yu <fenghua.yu@intel.com>
>  L:	lm-sensors@lm-sensors.org
>  S:	Maintained
>  F:	Documentation/hwmon/coretemp

Applied, thanks.

-- 
Jean Delvare
