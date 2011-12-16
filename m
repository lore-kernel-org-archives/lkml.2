Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760477Ab1LPSel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:34:41 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56903 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759034Ab1LPSed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:34:33 -0500
Date: Fri, 16 Dec 2011 13:32:27 -0500 (EST)
Message-Id: <20111216.133227.782560339712731597.davem@davemloft.net>
To: jkosina@suse.cz
Cc: aurel@gnuage.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] asix: new device id
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.1112161737040.15661@twin.jikos.cz>
References: <1324050921-9007-1-git-send-email-aurel@gnuage.org>
	<alpine.LRH.2.00.1112161737040.15661@twin.jikos.cz>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 16 Dec 2011 10:32:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Fri, 16 Dec 2011 17:38:13 +0100 (CET)

> On Fri, 16 Dec 2011, Aurelien Jacobs wrote:
> 
>> Adds the device id needed for the USB Ethernet Adapter delivered by
>> ASUS with their Zenbook.
>> 
>> Signed-off-by: Aurelien Jacobs <aurel@gnuage.org>
>> ---
>>  drivers/net/usb/asix.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>> 
>> diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
>> index e6fed4d..e95f0e6 100644
>> --- a/drivers/net/usb/asix.c
>> +++ b/drivers/net/usb/asix.c
>> @@ -1655,6 +1655,10 @@ static const struct usb_device_id	products [] = {
>>  	// ASIX 88772a
>>  	USB_DEVICE(0x0db0, 0xa877),
>>  	.driver_info = (unsigned long) &ax88772_info,
>> +}, {
>> +	// Asus USB Ethernet Adapter
>> +	USB_DEVICE (0x0b95, 0x7e2b),
>> +	.driver_info = (unsigned long) &ax88772_info,
>>  },
>>  	{ },		// END
>>  };
> 
> Adding netdev to CC so that it doesn't get lost.

Only submitting the actual patch, unquoted, to netdev makes sure it gets
queued up in patchwork, and therefore not lost.
