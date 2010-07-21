Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762116Ab0GUFy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:54:29 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33616 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab0GUFy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 01:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OE8747BhzMKCmk4/xlEi8G6uu8sLq39PEh+CQ8R5twz2LJbSGDQ0baUHZWN44Hyuvm
         Me+vu/utJbkkTH2VjJ3TNOG6qmKCs1JMV+ARRwjBPNuLP7M0hJR0KDHmI9CMzZS2mTy2
         mJg51RUjMxz4JxgqNhw19Z7hsC1qMhp/xyLuc=
Message-ID: <4C468BA0.6050504@gmail.com>
Date: Tue, 20 Jul 2010 22:54:40 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Weber <thomas.weber.linux@googlemail.com>
CC: trivial@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 134/134]Documentation/w1/masters/omap-hdq update web address.
References: <1279688336-29735-1-git-send-email-justinmattock@gmail.com> <1279688336-29735-14-git-send-email-justinmattock@gmail.com> <4C4688C3.1050105@gmail.com>
In-Reply-To: <4C4688C3.1050105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 10:42 PM, Thomas Weber wrote:
> Am 21.07.2010 06:58, schrieb Justin P. Mattock:
>> The patch below updates a broken web address pointing to
>> the comapny due to not being able to find the original content.
>> if you know let me know.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   Documentation/w1/masters/omap-hdq |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/Documentation/w1/masters/omap-hdq b/Documentation/w1/masters/omap-hdq
>> index ca722e0..fcd228e 100644
>> --- a/Documentation/w1/masters/omap-hdq
>> +++ b/Documentation/w1/masters/omap-hdq
>> @@ -7,7 +7,7 @@ Supported chips:
>>
>>   A useful link about HDQ basics:
>>   ===============================
>> -http://focus.ti.com/lit/an/slua408/slua408.pdf
>> +http://www.ti.com/
>>
>>   Description:
>>   ============
>
> http://focus.ti.com/lit/an/slua408a/slua408a.pdf
>

slua408a.pdf so the small "a" made this thing work..
Thanks for sending the address ill resend an updated patch

Justin P. Mattock
