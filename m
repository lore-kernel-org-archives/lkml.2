Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab2ACNSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 08:18:03 -0500
Received: from [89.21.227.130] ([89.21.227.130]:36277 "EHLO
	mail.epsilon.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752181Ab2ACNSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 08:18:02 -0500
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jan 2012 08:18:01 EST
Message-ID: <4F02FE17.2000800@itdev.co.uk>
Date: Tue, 03 Jan 2012 13:09:43 +0000
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Chase Douglas <chasedouglas@gmail.com>
CC: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: multitouch: add support of Atmel multitouch
 panels
References: <1324651260-4067-1-git-send-email-benjamin.tissoires@gmail.com> <1324651260-4067-2-git-send-email-benjamin.tissoires@gmail.com> <4EF4CE4A.1020907@gmail.com>
In-Reply-To: <4EF4CE4A.1020907@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chase Douglas wrote:
> On 12/23/2011 06:40 AM, Benjamin Tissoires wrote:
>> Signed-off-by: Benjamin Tissoires<benjamin.tissoires@gmail.com>
>> ---
>>   drivers/hid/Kconfig          |    1 +
>>   drivers/hid/hid-ids.h        |    3 +++
>>   drivers/hid/hid-multitouch.c |    5 +++++
>>   3 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
>> index 5d6eb4e..e95b07c 100644
>> --- a/drivers/hid/Kconfig
>> +++ b/drivers/hid/Kconfig
>> @@ -335,6 +335,7 @@ config HID_MULTITOUCH
>>   	  Say Y here if you have one of the following devices:
>>   	  - 3M PCT touch screens
>>   	  - ActionStar dual touch panels
>> +	  - Atmel panels
>>   	  - Cando dual touch panels
>>   	  - Chunghwa panels
>>   	  - CVTouch panels
>
> I'm guessing this is different than the Atmel maXTouch chips. If so, can
> you figure out a model name so people aren't confused on which driver to
> use?

It is in fact a maXTouch chip - there are several different chips which 
are able to register as a USB digitizer device using that VID/PID.

-- 
Nick Dyer
Software Engineer, ITDev Ltd
Hardware and Software Development Consultancy
Website: http://www.itdev.co.uk
