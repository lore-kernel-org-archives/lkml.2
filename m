Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1HSUym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 16:54:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63445 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1HSUyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 16:54:41 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Per Forlin" <per.forlin@linaro.org>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [PATCH v6] usb: gadget: storage: make FSG_NUM_BUFFERS variable
 size
References: <1313781687-13955-1-git-send-email-per.forlin@linaro.org>
Date: Fri, 19 Aug 2011 22:54:38 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v0ha1cbg3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1313781687-13955-1-git-send-email-per.forlin@linaro.org>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011 21:21:27 +0200, Per Forlin <per.forlin@linaro.org>  
wrote:
> FSG_NUM_BUFFERS is set to 2 as default.
> Usually 2 buffers are enough to establish a good buffering pipeline.
> The number may be increased in order to compensate a for bursty VFS
> behaviour.
>
> Here follows a description of system that may require more than
> 2 buffers.
>  * CPU ondemand governor active
>  * latency cost for wake up and/or frequency change
>  * DMA for IO
>
> Use case description.
>  * Data transfer from MMC via VFS to USB.
>  * DMA shuffles data from MMC and to USB.
>  * The CPU wakes up every now and then to pass data in and out from VFS,
>    which cause the bursty VFS behaviour.

> Signed-off-by: Per Forlin <per.forlin@linaro.org>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
