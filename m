Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1FHTdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:33:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40694 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab1FHTag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:30:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HE1PxbqGN7V42G1S+7YG/VYXQmZzbFMjOCgNyZpeOkd1PsGNbaSvktrL7Ty0LoViQ9
         mhe6TIJrJnQm2bFAIhLQiCd1Rbua8KqCFmt8e0TFEeLPJXErx10rOeXW0ImXDt44zcdv
         eDU47q4txXB1VdZQtEDHRiA2IQBkUH5AzjJzY=
Message-ID: <4DEFCC76.5050409@gmail.com>
Date: Wed, 08 Jun 2011 21:24:38 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, xiyou.wangcong@gmail.com,
        stevie.trujillo@gmail.com, kyungmin.park@samsung.com
Subject: Re: [PATCH 2/2 v2] ramoops: add new line to each print
References: <4DE10B58.1010005@gmail.com>  <4DEE5737.9060404@gmail.com>	 <1307550164.16453.2.camel@Joe-Laptop>  <4DEFC885.2080202@gmail.com> <1307561264.16453.10.camel@Joe-Laptop>
In-Reply-To: <1307561264.16453.10.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/06/2011 21:27, Joe Perches ha scritto:
> On Wed, 2011-06-08 at 21:07 +0200, Marco Stornelli wrote:
>> From: Marco Stornelli<marco.stornelli@gmail.com>
>> Add new line to each print.
>> diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
> []
>> @@ -186,6 +188,8 @@ static int __init ramoops_init(void)
>>   		 * if we didn't find a platform device, we use module parameters
>>   		 * building platform data on the fly.
>>   		 */
>> +		pr_info("platform device not found, "
>> +			"using module parameters\n");
>
> Thanks Marco, I think that looks better.
>
> Trivia:
>
> This fits on a single line and it's not generally a
> good thing to split a format across multiple lines.
>
> cheers, Joe

Mmmm...my editor said 81 cols, so I split the message into two lines. 
I'll check it again.

Marco
