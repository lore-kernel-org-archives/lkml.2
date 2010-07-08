Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab0GHS5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 14:57:01 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32175 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab0GHS47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 14:56:59 -0400
Date: Thu, 08 Jul 2010 20:58:11 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv2 1/2] USB: gadget: mass/file storage: set serial number
In-reply-to: <20100708183425.GB31823@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org,
       Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
       stable <stable@kernel.org>
Message-id: <op.vfjga9ie7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <c73431dbedd41f94c5f471fb5e466943cee870c1.1277974263.git.m.nazarewicz@samsung.com>
 <624a27be8a9a4492976afaa8df78c07051cc6e25.1277987700.git.m.nazarewicz@samsung.com>
 <20100708183425.GB31823@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jul 01, 2010 at 03:42:19PM +0200, Michal Nazarewicz wrote:
>> This commit adds iSerialNumber to all gadgets that use the Mass
>> Storage Function.  It appears that Windows has problems when
>> it is not set.
>>
>> Not to copy the same code all over again, a fsg_string_serial_fill()
>> macro has been added to the storage_common.c file which is now also
>> used in the File Storage Gadget.

On Thu, 08 Jul 2010 20:34:25 +0200, Greg KH <greg@kroah.com> wrote:
> This patch conflicts with the patch in my tree:
> 	Subject: USB: Add a serial number parameter to g_file_storage module

Ah, there it is...  I remembered this patch but couldn't find it so assumed
that it didn't make it to your tree after all.  But there it is...

> So, could you fix the above patch up to play nice with your change so
> that I can accept it?

Sure thing.  If I won't post it within 2h I'll do that after the weekend
(read Monday).

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
