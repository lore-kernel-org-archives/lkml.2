Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1FAVy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 17:54:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27816 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab1FAVyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 17:54:25 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6364"; a="94964800"
From: David Brown <davidb@codeaurora.org>
To: Joe Perches <joe@perches.com>, carlv@codeaurora.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH 1/6] MAINTAINERS: Update MSM pattern
References: <cover.1306950701.git.joe@perches.com>
	<326591b5bd7f016a40a325fa0a532bfab47218d6.1306950701.git.joe@perches.com>
Date: Wed, 01 Jun 2011 14:54:24 -0700
In-Reply-To: <326591b5bd7f016a40a325fa0a532bfab47218d6.1306950701.git.joe@perches.com>
	(Joe Perches's message of "Wed, 1 Jun 2011 10:59:09 -0700")
Message-ID: <8yay61lxlnz.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01 2011, Joe Perches wrote:

> Video MSM is still in staging.

It also appears to be in drivers/video/msm

Carl, do we need the staging driver any more?

I don't have any problem removing the drivers/platform/msm line, since
that now appears to have been an ill-formed idea, but I'd rather just
get rid of the staging video driver.

David

> cc: David Brown <davidb@codeaurora.org>
> cc: Daniel Walker <dwalker@fifo99.com>
> cc: Bryan Huntsman <bryanh@codeaurora.org>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 29801f7..ae06910 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -926,7 +926,7 @@ F:	drivers/mmc/host/msm_sdcc.c
>  F:	drivers/mmc/host/msm_sdcc.h
>  F:	drivers/tty/serial/msm_serial.h
>  F:	drivers/tty/serial/msm_serial.c
> -F:	drivers/platform/msm/
> +F:	drivers/staging/msm/
>  F:	drivers/*/pm8???-*
>  F:	include/linux/mfd/pm8xxx/
>  T:	git git://codeaurora.org/quic/kernel/davidb/linux-msm.git

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
