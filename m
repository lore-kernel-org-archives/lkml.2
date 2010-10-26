Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab0JZPY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:24:28 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49559 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab0JZPY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:24:27 -0400
Date: Tue, 26 Oct 2010 17:26:47 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 1/7] USB: gadget: file_storage: put_device() in error
 recovery
In-reply-to: <Pine.LNX.4.44L0.1010261113320.1634-100000@iolanthe.rowland.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Message-id: <op.vk6vuxix7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.62 (Linux)
References: <Pine.LNX.4.44L0.1010261113320.1634-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010 17:14:52 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 26 Oct 2010, [utf-8] MichaÅ‚ Nazarewicz wrote:
>
>> >> +		if ((rc = device_create_file(&curlun->dev, &dev_attr_ro))  ||
>> >> +		    (rc = device_create_file(&curlun->dev, &dev_attr_nofua)) ||
>> >> +		    (rc = device_create_file(&curlun->dev, &dev_attr_file)))
>> >> +			goto out;
>> >
>> > As long as you're changing these anyway, you may as well use the style
>> > most developers seem to prefer:
>> >
>> > 		rc = device_create_file(&curlun->dev, &dev_attr_ro);
>> > 		if (rc)
>> > 			goto out;
>> > 		...
>>
>> But then it'd be total of 9 lines consisting of three 3-line ifs.  I decided
>> that it would be more readable with a single if even though it is not compliant
>> with coding style.  What do you think?  I can just resend it.
>
> I think you should change it as I suggested.

OK, I'll resend the whole set tomorrow or the day after tomorrow.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
