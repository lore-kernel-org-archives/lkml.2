Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab1GKCVF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 22:21:05 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:34077 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab1GKCVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 22:21:02 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.13 with qID p6B2KnMU006346, This message is released by code: ctaloc0852
X-BOX-Message-Id: p6B2KnMU006346
Message-ID: <4E1A5D8F.2020600@realsil.com.cn>
Date: Mon, 11 Jul 2011 10:18:55 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110628 Thunderbird/5.0
MIME-Version: 1.0
To: =?UTF-8?B?546L54Kc?= <wei_wang@realsil.com.cn>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix a miswriting in ext_sd_send_cmd_get_rsp
References: <1310350393-6261-1-git-send-email-wei_wang@realsil.com.cn>
In-Reply-To: <1310350393-6261-1-git-send-email-wei_wang@realsil.com.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年07月11日 10:13, 王炜 wrote:
> From: wwang<wei_wang@realsil.com.cn>
>
> cppcheck reported: [staging/rts_pstor/sd.c:3730] ->  [staging/rts_pstor/sd.c:3726]: (style) Found duplicate if expressions.
> It's a miswriting, and the second if expression should be "(rsp_type == SD_RSP_TYPE_R0)"
>
> Signed-off-by: wwang<wei_wang@realsil.com.cn>
> ---
>   drivers/staging/rts_pstor/sd.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
> index e4b3891..8db14dd 100644
> --- a/drivers/staging/rts_pstor/sd.c
> +++ b/drivers/staging/rts_pstor/sd.c
> @@ -3747,7 +3747,7 @@ RTY_SEND_CMD:
>   				if ((ptr[3]&  0x1E) != 0x04) {
>   					TRACE_RET(chip, STATUS_FAIL);
>   				}
> -			} else if (rsp_type == SD_RSP_TYPE_R2) {
> +			} else if (rsp_type == SD_RSP_TYPE_R0) {
>   				if ((ptr[3]&  0x1E) != 0x03) {
>   					TRACE_RET(chip, STATUS_FAIL);
>   				}

Dear all:

     Sorry to bother, please ignore this mail, I will modify the log 
resend again.

     Best regards,
     wwang

