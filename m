Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1KRKsC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:48:02 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:43612 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414Ab1KRKr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:47:59 -0500
Message-ID: <4EC637D9.7000201@ti.com>
Date: Fri, 18 Nov 2011 16:17:53 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C: Make i2cdev_detach_adapter static
References: <1321605731-3098-1-git-send-email-shubhrajyoti@ti.com> <20111118104317.7d150bab@endymion.delvare>
In-Reply-To: <20111118104317.7d150bab@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 November 2011 03:13 PM, Jean Delvare wrote:
> On Fri, 18 Nov 2011 14:12:11 +0530, Shubhrajyoti D wrote:
>> The function i2cdev_detach_adapter is used only in i2c-dev file
>> making it static.
> This description doesn't match what the patch actually does. Please
> resubmit with proper subject and description.
Yes will correct it.
>> Also removes the following sparse warning
>>
>> drivers/i2c/i2c-dev.c:582:5: warning: symbol 'i2cdev_notifier_call'
>> was not declared. Should it be static?
>>
>> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
>> ---
>>  drivers/i2c/i2c-dev.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
>> index c90ce50..57a45ce 100644
>> --- a/drivers/i2c/i2c-dev.c
>> +++ b/drivers/i2c/i2c-dev.c
>> @@ -579,7 +579,7 @@ static int i2cdev_detach_adapter(struct device *dev, void *dummy)
>>  	return 0;
>>  }
>>  
>> -int i2cdev_notifier_call(struct notifier_block *nb, unsigned long action,
>> +static int i2cdev_notifier_call(struct notifier_block *nb, unsigned long action,
>>  			 void *data)
>>  {
>>  	struct device *dev = data;
>

