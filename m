Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab0JNUjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 16:39:40 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62340 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023Ab0JNUjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 16:39:39 -0400
Message-ID: <4CB76A3F.5070903@oracle.com>
Date: Thu, 14 Oct 2010 13:38:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        driverdevel <devel@driverdev.osuosl.org>, gregkh@suse.de
Subject: Re: mmotm 2010-10-13-17-13 uploaded (staging/bcm)
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org> <20101013211754.ba0d84f5.randy.dunlap@oracle.com> <20101014191447.GF11510@kroah.com>
In-Reply-To: <20101014191447.GF11510@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/10 12:14, Greg KH wrote:
> On Wed, Oct 13, 2010 at 09:17:54PM -0700, Randy Dunlap wrote:
>> On Wed, 13 Oct 2010 17:13:25 -0700 akpm@linux-foundation.org wrote:
>>
>>> The mm-of-the-moment snapshot 2010-10-13-17-13 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> and will soon be available at
>>>
>>>    git://zen-kernel.org/kernel/mmotm.git
>>>
>>> It contains the following patches against 2.6.36-rc7:
>>
>>
>> drivers/staging/bcm/Bcmnet.c:24: error: 'struct net_device' has no member named 'refcnt'
>> drivers/staging/bcm/Bcmnet.c:24: error: 'struct net_device' has no member named 'refcnt'
>> drivers/staging/bcm/Bcmnet.c:24: error: 'struct net_device' has no member named 'refcnt'
>> drivers/staging/bcm/Bcmnet.c:26: error: 'struct net_device' has no member named 'refcnt'
>> drivers/staging/bcm/Bcmnet.c:31: error: 'struct net_device' has no member named 'refcnt'
>> drivers/staging/bcm/Bcmnet.c:31: error: 'struct net_device' has no member named 'refcnt'
>> drivers/staging/bcm/Bcmnet.c:31: error: 'struct net_device' has no member named 'refcnt'
>> drivers/staging/bcm/Bcmnet.c:33: error: 'struct net_device' has no member named 'refcnt'
>> drivers/staging/bcm/Bcmnet.c:34: error: 'struct net_device' has no member named 'refcnt'
>> drivers/staging/bcm/Bcmnet.c:35: error: 'struct net_device' has no member named 'refcnt'
> 
> Very wierd, is this coming from some other net_device structure change
> in linux-next or mm?

in linux-next:

include/linux/netdevice.h:

< 	atomic_t		refcnt ____cacheline_aligned_in_smp;
> 	int __percpu		*pcpu_refcnt;

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
