Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762675Ab0GUGoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 02:44:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65170 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762569Ab0GUGoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 02:44:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=q5NQ9fyso7saLczJcAntl3b2TkR+sL8Zfi9DTYfoII47rLwqna2wHKLQnbY/hWGz0e
         YuotXqIQWMrxVL51jlPk+rGe03t+qzs4JJMVgeeJ7e4cteDUGToZCK8qZStGcJJPDFN+
         rqCiPBPqIYsWvibQUHM2qQfwh8sdCbjVe+gos=
Message-ID: <4C469751.6010306@gmail.com>
Date: Tue, 20 Jul 2010 23:44:33 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Weber <thomas.weber.linux@googlemail.com>
CC: trivial@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 41/41]Documentation/hwmon/thmc50 update web address.
References: <1279687982-29413-1-git-send-email-justinmattock@gmail.com> <1279687982-29413-11-git-send-email-justinmattock@gmail.com> <4C468CE9.5050002@gmail.com>
In-Reply-To: <4C468CE9.5050002@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 11:00 PM, Thomas Weber wrote:
> Am 21.07.2010 06:52, schrieb Justin P. Mattock:
>> The patch below updates a broken web address.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   Documentation/hwmon/thmc50 |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/Documentation/hwmon/thmc50 b/Documentation/hwmon/thmc50
>> index 9639ca9..8a7772a 100644
>> --- a/Documentation/hwmon/thmc50
>> +++ b/Documentation/hwmon/thmc50
>> @@ -9,7 +9,7 @@ Supported chips:
>>     * Texas Instruments THMC50
>>       Prefix: 'thmc50'
>>       Addresses scanned: I2C 0x2c - 0x2e
>> -    Datasheet: http://focus.ti.com/docs/prod/folders/print/thmc50.html
>> +    Datasheet: http://www.ti.com/
>>
>>   Author: Krzysztof Helt<krzysztof.h1@wp.pl>
>>
>
> Hello Justin,
>
> the page still exist. The product is only marked obsolete.
>
> Thomas
>


ah thanks.. my eyes are going bad.. All I remember was seeing a big 
hazard sign indicating to me error or something..didnt even see the 
obsolete in there.

alright then this  one Ill throw in my Nacked pile..

Justin P. Mattock
