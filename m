Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab2G3Mjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 08:39:33 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:19799 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab2G3Mjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 08:39:31 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFIiy0PE5gu
X-RZG-CLASS-ID: mo00
Date: Mon, 30 Jul 2012 14:39:27 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, kys@microsoft.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH net,1/1] hyperv: Add support for setting MAC from within
 guests
Message-ID: <20120730123927.GA29459@aepfle.de>
References: <1341940762-18307-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1341940762-18307-1-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21.rev5555 (2012-07-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, Haiyang Zhang wrote:

> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
> index 981ebb1..fbf5394 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -47,6 +48,7 @@ struct rndis_request {
>  	struct hv_page_buffer buf;
>  	/* FIXME: We assumed a fixed size request here. */
>  	struct rndis_message request_msg;
> +	u8 ext[100];

This array is not referenced in the patch.
Please add a comment to the code what the purpose of this array is, and
why its size is 100 bytes.

Thanks.

Olaf
