Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab2E0U7I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 16:59:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33738 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab2E0U7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 16:59:04 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Felipe Balbi" <balbi@ti.com>, panto@antoniou-consulting.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: f_mass_storage: change default value of the
 removable parameter
References: <Pine.LNX.4.44L0.1205271201460.14937-100000@netrider.rowland.org>
Date: Sun, 27 May 2012 13:59:00 -0700
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wezi8ms73l0zgt@mpn-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1205271201460.14937-100000@netrider.rowland.org>
User-Agent: Opera Mail/11.64 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 26 May 2012, Michal Nazarewicz wrote:
>> This commit changes the default value of the removable module parameter
>> from “y” to “n”.  This comes with line with file_storag's default and
>> seems to be a better default.
>>
>> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
>> ---
>>  drivers/usb/gadget/f_mass_storage.c |    6 ++----
>>  1 files changed, 2 insertions(+), 4 deletions(-)
>>
>> Alternatively I can add a warning about the default being changed and
>> schedule the change for the future.  Dunno if it's worth it.

On Sun, 27 May 2012 09:03:26 -0700, Alan Stern <stern@rowland.harvard.edu> wrote:
> I think this patch is good as it stands.
>
> Would you like to write a gadget-mass-storage.txt file for
> Documentation/usb?  Putting all the instructions for using the
> mass-storage gadget in a recognized place would help people to find it.

Sure.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
