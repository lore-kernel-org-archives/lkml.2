Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750825Ab2GQEJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 00:09:18 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:33139 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab2GQEJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 00:09:16 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFJji0PEBZF
X-RZG-CLASS-ID: mo00
Date: Tue, 17 Jul 2012 06:09:13 +0200
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com
Subject: Re: [PATCH 02/15] Drivers: hv: Add KVP definitions for IP address
 injection
Message-ID: <20120717040912.GA6369@aepfle.de>
References: <1342297930-12607-1-git-send-email-kys@microsoft.com>
 <1342298060-12662-1-git-send-email-kys@microsoft.com>
 <1342298060-12662-2-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1342298060-12662-2-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, K. Y. Srinivasan wrote:

> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 68ed7f7..38b561a 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -127,6 +127,8 @@ enum hv_kvp_exchg_op {
>  	KVP_OP_SET,
>  	KVP_OP_DELETE,
>  	KVP_OP_ENUMERATE,
> +	KVP_OP_GET_IP_INFO,
> +	KVP_OP_SET_IP_INFO,
>  	KVP_OP_REGISTER,
>  	KVP_OP_COUNT /* Number of operations, must be last. */
>  };

I think this will break the kernel/daemon API for existing binaries.
Perhaps a forward/backwards compatible API where an older binary
continues to work with a newer kernel should be added.

Olaf
