Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab1HZS5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:57:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8359 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1HZS5G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:57:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:date:
	mime-version:content-transfer-encoding:from:organization:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=xCm/B2fbl1XH886BYr8MkIiPkMrq7zSTmHrZTftxlSU4GvMK0vqNrWwNJjpMbMbJz
	Sq8+dNaVtjlLDjKftzjHA==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Greg KH" <greg@kroah.com>, "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Felipe Balbi" <balbi@ti.com>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 1/4] usb: Provide usb_speed_string() function
References: <Pine.LNX.4.44L0.1108261437200.2275-100000@netrider.rowland.org>
Date: Fri, 26 Aug 2011 20:57:01 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Message-ID: <op.v0t39bd1vgw7ix@mnazarewicz-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1108261437200.2275-100000@netrider.rowland.org>
User-Agent: Opera Mail/11.50 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011 20:49:05 +0200, Alan Stern <stern@rowland.harvard.edu>  
wrote:
> I don't know.  Michal, can you look into this?  What we want is:
>
> 	common.o gets included in the main kernel if either CONFIG_USB
> 	or CONFIG_USB_GADGET is set to Y.
>
> 	Otherwise, if either symbol is set to M then common.o gets
> 	built into its own little module.  Perhaps some other stuff
> 	could get put in there too, though at the moment I can't
> 	think of anything.

Wouldn't that be accomplished by a tristate Kconfig option selected by
USB and USB_GADGET?  Or a tristate that defaults to “y” but depends on
USB or USB_GADGET?

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
