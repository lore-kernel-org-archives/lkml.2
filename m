Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762690Ab0GUGqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 02:46:46 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59572 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762569Ab0GUGqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 02:46:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cATCAl8F+H9CS6HHRAOI3UUD3dqBNIMcH4vOkB3YDTuo8YDgoNw/U3CVKfXT0UdaNl
         bUf+erwEY5PV3ykKQdZo5JOMC5Z3/srQ/PShO1wlgShS65HIYJQPmQnll6XC1+/JffDm
         t3qc3HfQ6eQBKR3jGKyw/eVInNxrFHW7GoRfI=
Message-ID: <4C4697E0.5040406@gmail.com>
Date: Tue, 20 Jul 2010 23:46:56 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Weber <thomas.weber.linux@googlemail.com>
CC: trivial@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 43/43]Documentation/hwmon/adm1026 update web address.
References: <1279687982-29413-1-git-send-email-justinmattock@gmail.com> <1279687982-29413-13-git-send-email-justinmattock@gmail.com> <4C468DD8.5090507@gmail.com>
In-Reply-To: <4C468DD8.5090507@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 11:04 PM, Thomas Weber wrote:
> Am 21.07.2010 06:53, schrieb Justin P. Mattock:
>> The patch below updates a broken web address to the company site
>> due to me being unable to locate the original content.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   Documentation/hwmon/adm1026 |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/Documentation/hwmon/adm1026 b/Documentation/hwmon/adm1026
>> index f4327db..b19a4f9 100644
>> --- a/Documentation/hwmon/adm1026
>> +++ b/Documentation/hwmon/adm1026
>> @@ -6,7 +6,7 @@ Supported chips:
>>       Prefix: 'adm1026'
>>       Addresses scanned: I2C 0x2c, 0x2d, 0x2e
>>       Datasheet: Publicly available at the Analog Devices website
>> -               http://www.analog.com/en/prod/0,,766_825_ADM1026,00.html
>> +               http://www.analog.com/
>>
>>   Authors:
>>           Philip Pokorny<ppokorny@penguincomputing.com>  for Penguin Computing
>
> Hello Justin,
>
> ADM1026 now sold by ON Semi.
>
> http://www.onsemi.com/PowerSolutions/product.do?id=ADM1026
>
> Thomas
>

yep thanks to mike for pointing that out.. searching actually works now 
for a part number instead of the not found messages I've been seeing 
because of the wrong site..

I'll resend.

Justin P. Mattock
