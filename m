Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0GHUBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:01:46 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34222 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0GHUBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:01:44 -0400
Date: Thu, 08 Jul 2010 22:02:56 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv2 1/2] USB: gadget: mass/file storage: set serial number
In-reply-to: <752897.66667.qm@web180316.mail.gq1.yahoo.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org,
       Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
       mina86@mina86.com
Message-id: <op.vfjja62m7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <752897.66667.qm@web180316.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >> This commit adds iSerialNumber to all gadgets that
>> use the Mass Storage Function.

On Thu, 08 Jul 2010 21:31:23 +0200, David Brownell <david-b@pacbell.net> wrote:
> Can it be made to do so only when the gadget
> hasn't been provided with one already?  Serial
> number module options are standard parts of the
> composite gadget framework...

I don't see a way for the gadget to know whether user gave the iSerialNumber
parameter (other then reading the iSerialNumber variable but I consider that
ugly).

Plus, in any event, gadget has to reserve a string ID for serial number
anyway.  Otherwise composite won't override the string.


PS. I've just spotted a bug in Yann's patch (string is not filled if
CONFIG_USB_FILE_STORAGE_TEST is undefined).  It's a trivial issue so
I'll fix it with updated version.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
