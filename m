Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab1HXN1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:27:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61657 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1HXN06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:26:58 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Dave Young" <hidave.darkstar@gmail.com>, "Felipe Balbi" <balbi@ti.com>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 3/4] usb: gadget: rename usb_gadget_driver::speed to
 max_speed
References: <cover.1314028707.git.mina86@mina86.com>
 <8289497114d3da8366ea7ed8397b4d3f16afb946.1314028707.git.mina86@mina86.com>
 <CABqxG0c=y=hH83CqHewnvrx+OHTLssymzu0Hai+kJzN6LTvYHw@mail.gmail.com>
 <20110824085828.GF12549@legolas.emea.dhcp.ti.com>
Date: Wed, 24 Aug 2011 15:26:55 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v0pzm5nv3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <20110824085828.GF12549@legolas.emea.dhcp.ti.com>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Aug 24, 2011 at 10:26:53AM +0800, Dave Young wrote:
>> Still missing drivers/usb/musb/musb_gadget for the speed check

Fixed.

On Wed, 24 Aug 2011 10:58:29 +0200, Felipe Balbi <balbi@ti.com> wrote:
> and the new DWC3 on Greg's usb-next branch.

Fixed.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
