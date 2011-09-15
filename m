Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934790Ab1IOUTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:19:37 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44074 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934640Ab1IOUTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:19:35 -0400
Date: Thu, 15 Sep 2011 23:08:53 +0300
From: Dan Carpenter <error27@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 06/20] Staging: hv: util: Properly handle util services
 in the util driver
Message-ID: <20110915200853.GJ3789@shale.localdomain>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-6-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315936796-20662-6-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 10:59:42AM -0700, K. Y. Srinivasan wrote:
> @@ -403,31 +384,13 @@ static void vmbus_process_offer(struct work_struct *work)
>  		spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
>  
>  		free_channel(newchannel);
> -	} else {
> +	} else
>  		/*
>  		 * This state is used to indicate a successful open
>  		 * so that when we do close the channel normally, we
>  		 * can cleanup properly
>  		 */
>  		newchannel->state = CHANNEL_OPEN_STATE;

It's not worth resending, but this should have kept the curly braces
for two style reasons.
1) If one side of the if else pair has braces the other side gets
braces too.
2) If it's more than one line, it gets braces even if it's not needed
for semantic reasons.

Sorry to email you these pedantic things, but if I don't then my OCD 
acts up and I feel all itchy for hours.  Also you have a similar
thing below as well.

regards,
dan carpenter

