Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab1IIKbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 06:31:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39430 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329Ab1IIKbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 06:31:00 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Greg KH" <gregkh@suse.de>,
        "Klaus Schwarzkopf" <schwarzkopf@sensortherm.de>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
 <20110908191146.GA8552@suse.de> <4E69D032.4050807@sensortherm.de>
Date: Fri, 09 Sep 2011 12:30:57 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v1jd5vfp3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <4E69D032.4050807@sensortherm.de>
User-Agent: Opera Mail/11.51 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Am 08.09.2011 21:11, schrieb Greg KH:
>> Do you really mean "any later version"?

On Fri, 09 Sep 2011 10:37:06 +0200, Klaus Schwarzkopf  
<schwarzkopf@sensortherm.de> wrote:
> The acm_ms.c file is heavly based on the cdc2.c file with this  
> paragraph. Can i change this without breaking the license?

Probably yes, since you're adding your copyright and you can say that
your changes are GPLv2 only and therefore in practice the whole file
becomes GPLv2 only.

If anyone cares about my interpretation and opinion, Greg did not ask
you to change it but rather whether you really mean “any later version”. ;)

>> These two paragraphs are not needed, and the address is a very bad idea
>> to include in any file as it changes over time and I don't think you
>> want to keep up with the address location of the FSF for the next 40+
>> years.

> OK, i remove this lines.
>
> Can i remove this lines in all files of the directory drivers/usb/gadget?

If you do, submit it as separate patch. :)

> +#define CDC_VENDOR_NUM	0x1d6b	/* Linux Foundation */
> +#define CDC_PRODUCT_NUM	0x0106	/* CDC Composite: ACM + MS*/
>
> I used the next free device ID from http://www.linux-usb.org/usb.ids, is  
> this ok?

IIRC, Greg is maintaining lists of IDs, so you need to ask him nicely for
one. ;)

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
