Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab2GYH7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 03:59:17 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:18092 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab2GYH7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 03:59:16 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFJjy0PE3ns
X-RZG-CLASS-ID: mo00
Date: Wed, 25 Jul 2012 09:59:12 +0200
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        apw@canonical.com, netdev@vger.kernel.org, ben@decadent.org.uk
Subject: Re: [PATCH 03/17] Drivers: hv: kvp: Cleanup error handling in KVP
Message-ID: <20120725075912.GA22443@aepfle.de>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-3-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1343145701-3691-3-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, K. Y. Srinivasan wrote:


> +++ b/drivers/hv/hv_kvp.c
> @@ -48,13 +48,24 @@ static struct {
>  	void *kvp_context; /* for the channel callback */
>  } kvp_transaction;
>  
> +/*
> + * Before we can accept KVP messages from the host, we need
> + * to handshake with the user level daemon. This state tarcks

tracks

> + * if we are in the handshake phase.
> + */

> -		 * Something failed or the we have timedout;
> +		 * Something failed or  we have timedout;

extra space

