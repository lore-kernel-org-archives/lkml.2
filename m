Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab2EIIDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:03:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41404 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab2EIIDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:03:44 -0400
X-AuditID: cbfee61a-b7b97ae000004342-10-4faa24de69a6
Message-id: <4FAA24DE.6000709@samsung.com>
Date: Wed, 09 May 2012 17:03:42 +0900
From: Minho Ban <mhban@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329
 Thunderbird/11.0.1
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] PM / Hibernate : Add wait for disk detection if
 resume_file is MAJOR:MINOR style
References: <4FA78724.5000401@samsung.com> <201205072139.20129.rjw@sisk.pl>
 <4FA8612F.70207@samsung.com> <201205082328.54057.rjw@sisk.pl>
In-reply-to: <201205082328.54057.rjw@sisk.pl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 06:28 AM, Rafael J. Wysocki wrote:
> On Tuesday, May 08, 2012, Minho Ban wrote:
>> On 05/08/2012 04:39 AM, Rafael J. Wysocki wrote:
>>>> +		int partno;
>>>> +		while (!get_gendisk(swsusp_resume_device, &partno))
>>>> +			msleep(10);
>>>> +	}
>>>> +
>>>>   Check_image:
>>>>  	pr_debug("PM: Hibernation image partition %d:%d present\n",
>>>>  		MAJOR(swsusp_resume_device), MINOR(swsusp_resume_device));
>>>
>>> Besides, I'd like the documentation to be updated to reflect this change too.
>>
>> Do you mean resumewait is needed to be updated in kernel-parameters.txt?
> 
> No, but it should be decumented what exactly is to be passed in
> the resume= command line option (in kernel-parameters.txt).  Please do that
> when you're at it.
> 
> Thanks,
> Rafael
> 

OK, I'll add some comment on the resume= to clarify what partition format could be 
used.

Regards,
Minho Ban
