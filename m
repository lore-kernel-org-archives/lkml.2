Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab1BXXIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 18:08:34 -0500
Received: from relais.videotron.ca ([24.201.245.36]:49102 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab1BXXIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 18:08:32 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 24 Feb 2011 18:08:31 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Kenneth Heitke <kheitke@codeaurora.org>
Cc: davidb@codeaurora.org, dima@android.com, linux-arm-msm@vger.kernel.org,
        tsoni@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        swetland@google.com, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] MAINTAINERS: Add drivers/msm to MSM subsystem
In-reply-to: <1298585954-22422-2-git-send-email-kheitke@codeaurora.org>
Message-id: <alpine.LFD.2.00.1102241807540.31831@xanadu.home>
References: <1298585954-22422-1-git-send-email-kheitke@codeaurora.org>
 <1298585954-22422-2-git-send-email-kheitke@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, Kenneth Heitke wrote:

> Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>

Acked-by: Nicolas Pitre <nico@fluxnic.net>


> ---
>  MAINTAINERS |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6f99e12..e2ca70b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -889,6 +889,7 @@ M:	Daniel Walker <dwalker@fifo99.com>
>  M:	Bryan Huntsman <bryanh@codeaurora.org>
>  L:	linux-arm-msm@vger.kernel.org
>  F:	arch/arm/mach-msm/
> +F:	drivers/msm/
>  F:	drivers/video/msm/
>  F:	drivers/mmc/host/msm_sdcc.c
>  F:	drivers/mmc/host/msm_sdcc.h
> -- 
> 1.7.3.3
> 
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
