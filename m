Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab1H1G45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 02:56:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47436 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750926Ab1H1G4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 02:56:54 -0400
Subject: Re: [PATCH 44/46] Staging: hv: vmbus: Fix checkpatch warnings in
 connection.c
From: Joe Perches <joe@perches.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
In-Reply-To: <1314469905-7058-44-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
	 <1314469905-7058-1-git-send-email-kys@microsoft.com>
	 <1314469905-7058-44-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Aug 2011 23:56:52 -0700
Message-ID: <1314514612.6852.11.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-27 at 11:31 -0700, K. Y. Srinivasan wrote:
> Fix checkpatch warnings in connection.c.
[]
> diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
[]
> @@ -220,11 +220,11 @@ static void process_chn_event(u32 relid)
>  	channel = relid2channel(relid);
>  
>  	spin_lock_irqsave(&channel->inbound_lock, flags);
> -	if (channel && (channel->onchannel_callback != NULL)) {
> +	if (channel && (channel->onchannel_callback != NULL))

Useless test for channel or bad placement for spin_lock.
channel has already been dereferenced by the spin_lock.


