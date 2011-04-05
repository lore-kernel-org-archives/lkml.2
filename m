Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab1DEJA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 05:00:28 -0400
Received: from smtp.nokia.com ([147.243.128.26]:29093 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab1DEJAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 05:00:25 -0400
Message-ID: <4D9ADA25.2090700@nokia.com>
Date: Tue, 5 Apr 2011 12:00:21 +0300
From: Ameya Palande <ameya.palande@nokia.com>
Organization: Nokia Oyj
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: ext Randy Dunlap <rdunlap@xenotime.net>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] Documentation: Gather led information in one place
References: <1301579724-29893-1-git-send-email-ameya.palande@nokia.com> <20110331084420.47eaa91c.rdunlap@xenotime.net>
In-Reply-To: <20110331084420.47eaa91c.rdunlap@xenotime.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.24.192]
X-OriginalArrivalTime: 05 Apr 2011 09:00:21.0979 (UTC) FILETIME=[E50AA2B0:01CBF36F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On 03/31/2011 06:44 PM, ext Randy Dunlap wrote:
> On Thu, 31 Mar 2011 16:55:24 +0300 Ameya Palande wrote:
>
>> Signed-off-by: Ameya Palande<ameya.palande@nokia.com>
>> ---
>>   Documentation/leds-class.txt       |   98 ------------------------------------
>>   Documentation/leds-lp3944.txt      |   50 ------------------
>>   Documentation/leds/leds-class.txt  |   98 ++++++++++++++++++++++++++++++++++++
>>   Documentation/leds/leds-lp3944.txt |   50 ++++++++++++++++++
>>   4 files changed, 148 insertions(+), 148 deletions(-)
>>   delete mode 100644 Documentation/leds-class.txt
>>   delete mode 100644 Documentation/leds-lp3944.txt
>>   create mode 100644 Documentation/leds/leds-class.txt
>>   create mode 100644 Documentation/leds/leds-lp3944.txt
>
> Applied, thanks.
>
> Please also create a patch for Documentation/leds/00-INDEX file.

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
