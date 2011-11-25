Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1KYEfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 23:35:52 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:48114 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750862Ab1KYEfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 23:35:52 -0500
Message-ID: <4ECF1A89.2070600@xenotime.net>
Date: Thu, 24 Nov 2011 20:33:13 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Rahul Bedarkar <rpal143@gmail.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [path] adding header info in raw.h
References: <CA+NV+Vkog3M6BMC9iMAdCJPbsDQUvPJx1ucsX5FV=kHJLu+ryw@mail.gmail.com> <CACVxJT8D_9T+N8siZBGMccjUTeyip5YxNPg_jFTjpE4Bwb+CLA@mail.gmail.com> <CA+NV+Vn7y7VNwuFueM2JeoXiA1azE_8pyAZwHi-M1EB0X-aBZg@mail.gmail.com>
In-Reply-To: <CA+NV+Vn7y7VNwuFueM2JeoXiA1azE_8pyAZwHi-M1EB0X-aBZg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 08:28 PM, Rahul Bedarkar wrote:
> On Thu, Nov 24, 2011 at 9:44 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> On Thu, Nov 24, 2011 at 1:09 PM, Rahul Bedarkar <rpal143@gmail.com> wrote:
>>> --- a/include/linux/raw.h
>>> +++ b/include/linux/raw.h
>>> @@ -1,3 +1,9 @@
>>> +/*
>>> +* include/linux/raw.h
>>> +*
>>> +* include file for raw block device drivers
>>> +*/
>>
>> Quite a useless comment.
>> Filename inside file especially.
>>
> I have seen File name inside file rbtree.h, it is 19th line in my repo.

It's still useless (and sometimes incorrect in files that have it).

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
