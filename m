Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab1ENCIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 22:08:39 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41799 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab1ENCIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 22:08:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=saY5gCzzvZ9C3HRD2PDvCRMldpWrX1ZuYSbseIyOmPqJFeb8LR+wlBPzsFGffWj4ch
         ki2YqNBhDWf/SQGsh9G9dAAOoV5I7GYCjS7s29jjVkbcbpd6p6YWONX2RHH3gxFRKUdH
         ql53RrQJtpE6g9EE9ctQ9fn3hc3AjsFQMTEJo=
Message-ID: <4DCDE422.6060808@gmail.com>
Date: Fri, 13 May 2011 20:08:34 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Tejun Heo <tj@kernel.org>, Michael Leun <lkml20100708@newton.leun.net>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jipeng2005@gmail.com
Subject: Re: AHCI driver problem on ICH (Re: AHCI driver problem on SB700/SB800
 w/ Acer Ferrari One)
References: <201105120025.34531.rjw@sisk.pl> <BANLkTimqxmbpP1-+HxhPQS-YoLTh=bHd1Q@mail.gmail.com> <201105132222.11582.rjw@sisk.pl> <201105132244.29605.rjw@sisk.pl>
In-Reply-To: <201105132244.29605.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2011 02:44 PM, Rafael J. Wysocki wrote:
> On Friday, May 13, 2011, Rafael J. Wysocki wrote:
>> On Friday, May 13, 2011, Tejun Heo wrote:
>>> Hello,
>>>
>>> Can you guys please take a look at bug#34692?  It seems to be the same problem.
>>>
>>>    https://bugzilla.kernel.org/show_bug.cgi?id=34692
>>
>> Yes, same issue.
>>
>>> The offending commit seems to be 270dac35c2.  Does reverting it
>>> resolves the problem for you guys too?
>>
>> Yes, it does.
>
> Would you object if I asked Linus to revert that commit?

Think that's likely the best solution for now. I'm guessing there's some 
case where link power management trips up the check that was added. Most 
or all existing released controllers don't need it so I think Jian could 
likely try again after 2.6.39.
