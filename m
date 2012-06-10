Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2FJXaF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 19:30:05 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60694 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2FJXaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 19:30:03 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1206101335510.31367-100000@netrider.rowland.org>
References: <1339291826-2547-1-git-send-email-linkinjeon@gmail.com>
	<Pine.LNX.4.44L0.1206101335510.31367-100000@netrider.rowland.org>
Date: Mon, 11 Jun 2012 08:30:01 +0900
Message-ID: <CAKYAXd_ty7DknEu98FphbijPwf7iTNvnCHV337PUzgi9ZM+BeA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] usb: storage: add support for write cache quirk on
 usb hdd
From: Namjae Jeon <linkinjeon@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James.Bottomley@hansenpartnership.com, gregkh@linuxfoundation.org,
        mdharm-usb@one-eyed-alien.net, sshtylyov@mvista.com,
        bvanassche@acm.org, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/11, Alan Stern <stern@rowland.harvard.edu>:
> On Sat, 9 Jun 2012, Namjae Jeon wrote:
>
>> Add support for write cache quirk on usb hdd. scsi driver will be set to
>> wce
>> by detecting write cache quirk in quirk list when plugging usb hdd.
>
>> --- a/include/linux/usb_usual.h
>> +++ b/include/linux/usb_usual.h
>> @@ -64,7 +64,9 @@
>>  	US_FLAG(NO_READ_CAPACITY_16,	0x00080000)		\
>>  		/* cannot handle READ_CAPACITY_16 */		\
>>  	US_FLAG(INITIAL_READ10,	0x00100000)			\
>> -		/* Initial READ(10) (and others) must be retried */
>> +		/* Initial READ(10) (and others) must be retried */	\
>> +	US_FLAG(WRITE_CACHE,	0x00200000)			\
>> +		/* Write Cache status is not available */
>
> The documentation for the new flag should be added in the same patch
> along with the flag itself.  There's no reason to have separate
> patches.
Hi. Alan.
Okay, I see. I will merge documentation patch with this patch.
Thank you.

>
> Alan Stern
>
>
