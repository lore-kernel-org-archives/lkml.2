Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab2FIQwu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 12:52:50 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63961 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2FIQws convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 12:52:48 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1206091131040.11334-100000@netrider.rowland.org>
References: <1339243754-2150-1-git-send-email-linkinjeon@gmail.com>
	<Pine.LNX.4.44L0.1206091131040.11334-100000@netrider.rowland.org>
Date: Sat, 9 Jun 2012 12:52:46 -0400
Message-ID: <CAKYAXd-UEz03dEvNj3TGexOFL4TXzW+AEbGB3iiz0boCZzvGsA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] usb: storage: update usb devices for write cache
 quirk in quirk list.
From: Namjae Jeon <linkinjeon@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James.Bottomley@hansenpartnership.com, gregkh@linuxfoundation.org,
        mdharm-usb@one-eyed-alien.net, sshtylyov@mvista.com,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/9 Alan Stern <stern@rowland.harvard.edu>:
> On Sat, 9 Jun 2012, Namjae Jeon wrote:
>
>> Update information of Segate Portable HDD and WD My Passport HDD in
>> quirk list.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
>> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> ---
>>  drivers/usb/storage/unusual_devs.h |   10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
>> index 1719886..1d895f4 100644
>> --- a/drivers/usb/storage/unusual_devs.h
>> +++ b/drivers/usb/storage/unusual_devs.h
>> @@ -2025,6 +2025,16 @@ UNUSUAL_DEV( 0xed10, 0x7636, 0x0001, 0x0001,
>>               "Digital MP3 Audio Player",
>>               USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_NOT_LOCKABLE ),
>>
>> +UNUSUAL_DEV(0x1058, 0x070A, 0x0000, 0x9999,
>> +             "Western Digital",
>> +             "My Passport HDD",
>> +             USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),
>> +
>> +UNUSUAL_DEV(0x0BC2, 0x2300, 0x0000, 0x9999,
>> +             "Seagate",
>> +             "Portable HDD",
>> +             USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),
>> +
>
> Entries must be sorted by Vendor ID and then Product ID.  Please put
> your new entries in the correct spot.
Okay, I will resend th patch after moving code.
Thanks.
>
> Alan Stern
>
