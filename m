Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1DEJBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 05:01:38 -0400
Received: from smtp.nokia.com ([147.243.128.24]:56751 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab1DEJBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 05:01:36 -0400
Message-ID: <4D9ADA58.9050806@nokia.com>
Date: Tue, 5 Apr 2011 12:01:12 +0300
From: Ameya Palande <ameya.palande@nokia.com>
Organization: Nokia Oyj
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: ext Randy Dunlap <rdunlap@xenotime.net>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] Documentation: Add Documentation/leds/00-INDEX
References: <20110331084420.47eaa91c.rdunlap@xenotime.net>	<1301648314-3441-1-git-send-email-ameya.palande@nokia.com> <20110401101701.e440ad6d.rdunlap@xenotime.net>
In-Reply-To: <20110401101701.e440ad6d.rdunlap@xenotime.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.24.192]
X-OriginalArrivalTime: 05 Apr 2011 09:01:13.0958 (UTC) FILETIME=[04060060:01CBF370]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On 04/01/2011 08:17 PM, ext Randy Dunlap wrote:
> On Fri,  1 Apr 2011 11:58:34 +0300 Ameya Palande wrote:
>
>> Signed-off-by: Ameya Palande<ameya.palande@nokia.com>
>
> Applied, thanks.
>
>> ---
>>   Documentation/leds/00-INDEX |   10 ++++++++++
>>   1 files changed, 10 insertions(+), 0 deletions(-)
>>   create mode 100644 Documentation/leds/00-INDEX
>>
>> diff --git a/Documentation/leds/00-INDEX b/Documentation/leds/00-INDEX
>> new file mode 100644
>> index 0000000..762d676
>> --- /dev/null
>> +++ b/Documentation/leds/00-INDEX
>> @@ -0,0 +1,10 @@
>> +00-INDEX
>> +	- This file
>> +leds-class.txt
>> +	- Info about led sysfs class
>> +leds-lp3944.txt
>> +	- Info on National Semiconductor LP3944 fun-light chip
>> +leds-lp5521.txt
>> +	- Info on National Semiconductor LP5521 led driver chip
>> +leds-lp5523.txt
>> +	- Info on National Semiconductor LP5523 led driver chip
>> --

Can you point me to your tree where you applied my commit?

Also I see following commit in latest linux mainline:

commit 9a684e19afc630e0763246ee79c0578c1a8eaee8
Author: Antonio Ospite <ospite@studenti.unina.it>
Date:   Mon Apr 4 15:08:46 2011 -0700

     Documentation: consolidate leds files to leds/ subdir

     leds: move leds-class documentation under the leds/ subdir.
     Add also a leds/00-INDEX file describing the files under leds/

     Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
     Acked-by: Richard Purdie <richard.purdie@linuxfoundation.org>
     Cc: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Cheers,
Ameya.
