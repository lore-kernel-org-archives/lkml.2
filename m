Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1CHSeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 13:34:17 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26289 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab1CHSeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 13:34:16 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6279"; a="78731680"
From: David Brown <davidb@codeaurora.org>
To: Kenneth Heitke <kheitke@codeaurora.org>
Cc: bryanh@codeaurora.org, dwalker@fifo99.com, dima@android.com,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tsoni@codeaurora.org, swetland@google.com, <akpm@linux-foundation.org>,
        <joe@perches.com>, <davem@davemloft.net>, <gregkh@suse.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v3 1/2] MAINTAINERS: Add drivers/platform/msm to MSM subsystem
References: <1299038465-11782-1-git-send-email-kheitke@codeaurora.org>
	<1299038465-11782-2-git-send-email-kheitke@codeaurora.org>
Date: Tue, 08 Mar 2011 10:34:17 -0800
In-Reply-To: <1299038465-11782-2-git-send-email-kheitke@codeaurora.org>
	(Kenneth Heitke's message of "Tue, 1 Mar 2011 21:01:04 -0700")
Message-ID: <8yalj0pjwba.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01 2011, Kenneth Heitke wrote:

> ---
>  MAINTAINERS |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 59869e4..696cb18 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -904,6 +904,7 @@ F:	drivers/mmc/host/msm_sdcc.c
>  F:	drivers/mmc/host/msm_sdcc.h
>  F:	drivers/tty/serial/msm_serial.h
>  F:	drivers/tty/serial/msm_serial.c
> +F:	drivers/platform/msm/
>  T:	git git://codeaurora.org/quic/kernel/davidb/linux-msm.git
>  S:	Maintained

This should be sent 'To' someone who will be able to bring this patch
into the tree.  Probably one of Andrew Morton or Greg KH should be made
the 'To' and this resent.  At a minimum, I would need one of them to
sign the patch off.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
