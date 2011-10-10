Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab1JJHk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 03:40:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49859 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab1JJHkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 03:40:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:date:
	mime-version:content-transfer-encoding:from:organization:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=Uk4vPc6lrvlNcKMsQgKzvIDatHU5g70/HwsjuUTkQBJJI+b7N9gaw0ivrwnv/R/h4
	KD0wfJCLviyKx9k3HwJHA==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
References: <cover.1314364322.git.mina86@mina86.com>
 <befb5cae917585ee1caee515426cb11045ce1d6b.1314364323.git.mina86@mina86.com>
 <20111010060212.GA31707@legolas.emea.dhcp.ti.com>
Date: Mon, 10 Oct 2011 09:40:09 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mpn@google.com>
Organization: Google
Message-ID: <op.v24kw72ipw9a85@mpn-glaptop>
In-Reply-To: <20111010060212.GA31707@legolas.emea.dhcp.ti.com>
User-Agent: Opera Mail/11.51 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011 08:02:14 +0200, Felipe Balbi <balbi@ti.com> wrote:

> On Fri, Aug 26, 2011 at 03:18:35PM +0200, Michal Nazarewicz wrote:
>> From: Michal Nazarewicz <mina86@mina86.com>
>>
>> This commit replaces usb_gadget's is_dualspeed field with
>> a max_speed field.
>
> missing Signed-off-by

Sorry, forgot about -s.  I'll try to send fixed patches later today
or tomorrow.
