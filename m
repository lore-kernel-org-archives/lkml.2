Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab0GIP4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:56:47 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:49537 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab0GIP4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:56:45 -0400
Message-ID: <4C3746B8.9050303@in.ibm.com>
Date: Fri, 09 Jul 2010 21:26:40 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-s390@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [-next July 9 - s390 ] Badness at fs/sysfs/symlink.c:82 during
 qeth initalization
References: <20100709150117.51612026.sfr@canb.auug.org.au> <4C36EF9C.7010804@in.ibm.com> <m1d3ux55od.fsf@fess.ebiederm.org> <4C36F974.4030608@in.ibm.com> <20100709142818.GB9041@kroah.com>
In-Reply-To: <20100709142818.GB9041@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Jul 09, 2010 at 03:57:00PM +0530, Sachin Sant wrote:
>   
>> Eric W. Biederman wrote:
>>     
>>>> With today's next(20100709) qeth interface fails to initialize
>>>> with following Badness message:
>>>>     sysfs: symlink across ns_types 0.0.6000/net:eth0 -> net/eth0
>>>>     
>>>>         
>>> Is this with CONFIG_SYSFS_DEPRECATED set?
>>>
>>> I think I may have made my warning check a little extra strict.
>>>   
>>>       
>> Yes.
>>
>> CONFIG_SYSFS_DEPRECATED=y
>> CONFIG_SYSFS_DEPRECATED_V2=y
>>     
>
> Why do you have those options enabled?  Does your userspace really
> require them?  I want to remove those options soon, and it would be good
> to find out what is still relying on them.
>
> If you disable those options, does it then work?
>   
Not sure when and why i enabled these options.

Without them i don't see any problem (including the badness).

Thanks
-Sachin

> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-s390" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

