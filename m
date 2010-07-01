Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab0GAK0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 06:26:16 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56804 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab0GAK0P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 06:26:15 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Thu, 01 Jul 2010 12:27:20 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 1/2] USB: gadget: mass/file storage: set serial number
In-reply-to: <c73431dbedd41f94c5f471fb5e466943cee870c1.1277974263.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org, Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org,
       Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
       stable <stable@kernel.org>
Message-id: <op.ve5tzutp7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <c73431dbedd41f94c5f471fb5e466943cee870c1.1277974263.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Jul 2010 11:17:46 +0200, Michal Nazarewicz <m.nazarewicz@samsung.com> wrote:
> This commit adds iSerialNumber to all gadgets that use the Mass
> Storage Function.  It appears that Windows has problems when
> it is not set.
>
> Not to copy the same code all over again, a fsg_string_serial_fill()
> macro has been added to the storage_common.c file which is now also
> used in the File Storage Gadget.

This patch applies to the -next and will work on it but neither of the
patches will work on .35-rc3 or older.

I've been testing everything on -next forgetting that it is a bit
ahead of the .35-rc3 and that there is no usb_string_ids_tab() in

Therefore, as far as stable kernels are concerned, disregard those two
patches.  I'll send an updated patch for stable in a minute.

Sorry about the confusion.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
