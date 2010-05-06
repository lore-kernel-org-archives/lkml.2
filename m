Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab0EFIoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 04:44:21 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50771 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0EFIoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 04:44:19 -0400
Date: Thu, 06 May 2010 10:44:39 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv4 0/8] The FunctionFS composite function
In-reply-to: <cover.1273054944.git.mina86@mina86.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>, linux-usb@vger.kernel.org
Cc: Michal Nazarewicz <mina86@mina86.com>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <op.vb9zwpwj7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <cover.1273054944.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 May 2010 12:53:10 +0200, Michal Nazarewicz <m.nazarewicz@samsung.com> wrote:
> The code has been tested with a user-space MTP driver and there was no
> problems including with setup requests.  As such, it is believed that
> the data transfers are reliable.


> At this point I have to admit that communication on EP0 has not yet
> been tested, so beware of bugs there.

This last sentence is of course incorrect.  EP0 has been tested as well
as the first sentence implies.  Again forgot to edit the whole cover
letter.  Sorry about the confusion.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
