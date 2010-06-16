Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab0FPQt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:49:56 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57236 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab0FPQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:49:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OIoKqgFzcwmFAyncbOufRfvU5sf9J5BgaCv0GIFHCtFg645azVl8QaPMOaeZUvRxI3
         pt93fveN1RExqJQ1VTZ9BnCYCGK0bg/0nurQ/siNB2qxIzaX+hInOQdkqgUG+deCSD6V
         059l8HeR3f7yVMID42MnKqecAw8UaESXMtpkw=
Message-ID: <4C1900AF.804@gmail.com>
Date: Wed, 16 Jun 2010 09:49:51 -0700
From: David Daney <david.s.daney@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] trivial: fix typos concerning "precedence"
References: <20100611101624.GD10894@pengutronix.de> <1276251424-12806-8-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1276251424-12806-8-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2010 03:17 AM, Uwe Kleine-König wrote:
> diff --git a/drivers/staging/octeon/cvmx-cmd-queue.c b/drivers/staging/octeon/cvmx-cmd-queue.c
> index e9809d3..976227b 100644
> --- a/drivers/staging/octeon/cvmx-cmd-queue.c
> +++ b/drivers/staging/octeon/cvmx-cmd-queue.c
> @@ -140,21 +140,21 @@ cvmx_cmd_queue_result_t cvmx_cmd_queue_initialize(cvmx_cmd_queue_id_t queue_id,
>   	if (qstate->base_ptr_div128) {
>   		if (max_depth != (int)qstate->max_depth) {
>   			cvmx_dprintf("ERROR: cvmx_cmd_queue_initialize: "
> -				"Queue already initialized with different "
> +				"Queue already initalized with different "
>   				"max_depth (%d).\n",
>   			     (int)qstate->max_depth);
>   			return CVMX_CMD_QUEUE_INVALID_PARAM;
>   		}
>   		if (fpa_pool != qstate->fpa_pool) {
>   			cvmx_dprintf("ERROR: cvmx_cmd_queue_initialize: "
> -				"Queue already initialized with different "
> +				"Queue already initalized with different "
>   				"FPA pool (%u).\n",
>   			     qstate->fpa_pool);
>   			return CVMX_CMD_QUEUE_INVALID_PARAM;
>   		}
>   		if ((pool_size>>  3) - 1 != qstate->pool_size_m1) {
>   			cvmx_dprintf("ERROR: cvmx_cmd_queue_initialize: "
> -				"Queue already initialized with different "
> +				"Queue already initalized with different "
>   				"FPA pool size (%u).\n",
>   			     (qstate->pool_size_m1 + 1)<<  3);
>   			return CVMX_CMD_QUEUE_INVALID_PARAM;

NAK!

I am not sure which dictionary you are using, but I would like to keep 
the spelling consistent with the American Heritage Dictionary of the 
English Language, Fourth Edition.  My reading indicates that no change 
is needed.

David Daney
