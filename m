Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab0DGPji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:39:38 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34752 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015Ab0DGPjf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:39:35 -0400
Date: Wed, 07 Apr 2010 17:39:35 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 1/8] USB: composite: allow optional removal of __init and
 __exit tags
In-reply-to: <20100407152852.GA13425@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, Peter Korsgaard <jacmet@sunsite.dk>,
       Rupesh Gujare <rupeshgujare@gmail.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <op.vastr9n67p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <cover.1270644740.git.mina86@mina86.com>
 <033ad254a3bba337e7a37cc6071b7debc7051801.1270644740.git.mina86@mina86.com>
 <20100407152852.GA13425@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Apr 07, 2010 at 03:41:28PM +0200, Michal Nazarewicz wrote:
>> The composite framework has been written using __init and __exit tags
>> to mark init and exit functions as such.  This works with most of the
>> composite gadgets however some may need to call init/exit functions
>> during normal operations.  One example is mass storage gadget which
>> needs to call exit functions.
>>
>> This patch allows gadgets to define USB_NO_INIT_SEGMENT or
>> USB_NO_EXIT_SEGMENT to remove the __init and __exit declarations
>> from composite framework.

On Wed, 07 Apr 2010 17:28:52 +0200, Greg KH <greg@kroah.com> wrote:
> How about we just drop the __init and __exit tags completly and then
> we don't have to propagate this mess any further?

Personally, I don't care, ;) so if you think it's better to drop it all
together I can change it in a future patch.

-- 
Best regards,                                           _     _
  .o. | Liege of Serenely Enlightened Majesty of       o' \,=./ `o
  ..o | Computer Science,  Michał "mina86" Nazarewicz     (o o)
  ooo +---[mina86@mina86.com]---[mina86@jabber.org]---ooO--(_)--Ooo--
