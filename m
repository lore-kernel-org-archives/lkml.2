Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab1JJGWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 02:22:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50785 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab1JJGWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 02:22:19 -0400
MIME-Version: 1.0
In-Reply-To: <20111010060212.GA31707@legolas.emea.dhcp.ti.com>
References: <cover.1314364322.git.mina86@mina86.com>
	<befb5cae917585ee1caee515426cb11045ce1d6b.1314364323.git.mina86@mina86.com>
	<20111010060212.GA31707@legolas.emea.dhcp.ti.com>
Date: Mon, 10 Oct 2011 14:22:18 +0800
Message-ID: <CABqxG0c91WhRXt2egU7VhXUkLLvj1+yiJ+hptos_ta_w39VJDA@mail.gmail.com>
Subject: Re: [PATCHv5 2/4] usb: gadget: replace "is_dualspeed" with "max_speed"
From: Dave Young <hidave.darkstar@gmail.com>
To: balbi@ti.com
Cc: Michal Nazarewicz <mnazarewicz@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove my another email addr <ruirui.r.yang@tieto.com> from cc list
which is not used now.

ditto other mails of this patch set
Michal, please also remove it if you resend or reply

On Mon, Oct 10, 2011 at 2:02 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Fri, Aug 26, 2011 at 03:18:35PM +0200, Michal Nazarewicz wrote:
>> From: Michal Nazarewicz <mina86@mina86.com>
>>
>> This commit replaces usb_gadget's is_dualspeed field with
>> a max_speed field.
>
> missing Signed-off-by
>
> --
> balbi
>



-- 
Regards
Dave
