Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab0JSSAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:00:05 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40067 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0JSSAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:00:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6141"; a="58429272"
Date: Tue, 19 Oct 2010 11:00:00 -0700
From: Larry Bassel <lbassel@codeaurora.org>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] usb: dummy_hcd code simplification
Message-ID: <20101019180000.GA3611@labbmf-linux.quicinc.com>
References: <1287495641-22802-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287495641-22802-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 Oct 10 15:40, Tatyana Brokhman wrote:
> Take handling of the control requests out from dummy_timer to a different
> function.
> 
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> ---
>  drivers/usb/gadget/dummy_hcd.c |  250 +++++++++++++++++++++-------------------
>  1 files changed, 134 insertions(+), 116 deletions(-)
> 
> diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
> index dc65462..ff93fea 100644
> --- a/drivers/usb/gadget/dummy_hcd.c
> +++ b/drivers/usb/gadget/dummy_hcd.c
> @@ -1195,6 +1195,138 @@ static struct dummy_ep *find_endpoint (struct dummy *dum, u8 address)
>  #define Ep_Request	(USB_TYPE_STANDARD | USB_RECIP_ENDPOINT)
>  #define Ep_InRequest	(Ep_Request | USB_DIR_IN)
>  
> +
> +/**
> + * handle_control_request() - handles all control transferes

"transfers" not "transferes".

> -- 
> 1.6.3.3
> 
> --
> Sent by an consultant of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
