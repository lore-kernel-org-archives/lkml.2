Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168Ab1FXBrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 21:47:04 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22461 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760005Ab1FXBrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 21:47:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6386"; a="99560409"
From: David Brown <davidb@codeaurora.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        devel@driverdev.osuosl.org, Ingo Molnar <mingo@elte.hu>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, Torben Hohn <torbenh@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 29/37] Remove unneeded version.h includes from drivers/staging/msm/
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
	<alpine.LNX.2.00.1106240054540.17688@swampdragon.chaosbits.net>
Date: Thu, 23 Jun 2011 18:47:01 -0700
In-Reply-To: <alpine.LNX.2.00.1106240054540.17688@swampdragon.chaosbits.net>
	(Jesper Juhl's message of "Fri, 24 Jun 2011 00:56:26 +0200 (CEST)")
Message-ID: <8yahb7g6lwq.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23 2011, Jesper Juhl wrote:

> It was pointed out by 'make versioncheck' that some includes of
> linux/version.h are not needed in drivers/staging/msm/.
> This patch removes them.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> diff --git a/drivers/staging/msm/msm_fb.c b/drivers/staging/msm/msm_fb.c
> index e7ef836..e60f8f9 100644
> --- a/drivers/staging/msm/msm_fb.c
> +++ b/drivers/staging/msm/msm_fb.c
> @@ -32,7 +32,6 @@
>  
>  #include <linux/workqueue.h>
>  #include <linux/string.h>
> -#include <linux/version.h>
>  #include <linux/proc_fs.h>
>  #include <linux/vmalloc.h>
>  #include <linux/debugfs.h>

Acked-by: David Brown <davidb@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
