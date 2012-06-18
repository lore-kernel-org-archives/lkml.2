Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab2FRPce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:32:34 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35283 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab2FRPcc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:32:32 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Felipe Balbi" <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] usb: gadget: mass_storage: require backing file for
 non-removable LUNs
References: <Pine.LNX.4.44L0.1206181016320.1591-100000@iolanthe.rowland.org>
Date: Mon, 18 Jun 2012 17:32:21 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mpn@google.com>
Organization: Google
Message-ID: <op.wf3ur7dppw9a85@mpn-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1206181016320.1591-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/12.00 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012 16:18:41 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:

> On Mon, 18 Jun 2012, Michal Nazarewicz wrote:
>
>> From: Michal Nazarewicz <mina86@mina86.com>
>>
>> The fsg_file_store() function does not check whether a LUN is removable or not
>> allowing one to specify an empty file name for a non-removable LUN.  This
>> commit adds explicit check of whether a file name is provided for
>> non-removable LUNs.
>
> Looks okay.  Note that in file_storage.c, the "file" attribute isn't
> writable if the LUN isn't removable, and the "ro" attribute isn't
> writable if the LUN is a cdrom.  Maybe you would prefer to do things
> that way instead.

Makes sense, I'll rewrite this patch to do that.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
