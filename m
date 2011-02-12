Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab1BLCtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 21:49:13 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:50565 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846Ab1BLCtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 21:49:12 -0500
Message-ID: <4D55F4B6.8040801@oracle.com>
Date: Fri, 11 Feb 2011 18:47:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Subject: Re: mmotm 2011-02-10-16-26 uploaded (zcache')
References: <201102110100.p1B10sDx029244@imap1.linux-foundation.org 53491.1297461155@localhost> <b4feb995-1e73-4c12-8c58-ad0c2252233c@default>
In-Reply-To: <b4feb995-1e73-4c12-8c58-ad0c2252233c@default>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D55F51E.0085:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/11/2011 2:09 PM, Dan Magenheimer wrote:
>> From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu]
>> Sent: Friday, February 11, 2011 2:53 PM
>> To: akpm@linux-foundation.org; Dan Magenheimer
>> Cc: mm-commits@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
>> mm@kvack.org; linux-fsdevel@vger.kernel.org
>> Subject: Re: mmotm 2011-02-10-16-26 uploaded
>>
>> On Thu, 10 Feb 2011 16:26:36 PST, akpm@linux-foundation.org said:
>>> The mm-of-the-moment snapshot 2011-02-10-16-26 has been uploaded to
>>>
>>>     http://userweb.kernel.org/~akpm/mmotm/
>>
>> CONFIG_ZCACHE=m dies a horrid death:
>
> Thanks Valdis.  A fix for this has already been posted by
> Nitin Gupta and Randy Dunlap here:
>
> https://lkml.org/lkml/2011/2/10/383
>
> Another patch for a zcache memory leak has been posted here:
>
> https://lkml.org/lkml/2011/2/10/306
>
> I'm sorry that multiple people have run into this in
> multiple trees.
> I have to admit I am a bit baffled as to what the proper
> tree flow is for bug fixes like this, but would be happy
> to "follow the process" if I am told what it is or if
> someone can point me to a document describing it.
>
> (Clearly making sure there are no bugs at all in a
> submission is the best way to go, but I'm afraid
> I can't claim to be perfect :-)

When CONFIG_SYSFS is not enabled:

mmotm-2011-0210-1626/drivers/staging/zcache/zcache.c:1608: error: 'ret' 
undeclared (first use in this function)

