Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab0G2NNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 09:13:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53024 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab0G2NNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 09:13:42 -0400
Message-ID: <4C517F59.5060507@ontolinux.com>
Date: Thu, 29 Jul 2010 15:17:13 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>, Minming Cao <bchociej@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Btrfs: Add hot data tracking functionality
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com> <4C4F6DF2.6090905@ontolinux.com> <1280354448.7694.4.camel@mingming-laptop> <20100729121729.GK655@dastard>
In-Reply-To: <20100729121729.GK655@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:ytNPSzsAyK9iseTZfm241cdcndZuwPW/e0n2FOV8YGg
 KCDnS3qJXzbE9+L2pTdlpXtrCy85TPZ30AOYSvJ08GtqGZgutQ
 3OllAju4ytsK1BOIVZHLlokcPAJaCIIqXaScBMi+mpGT25XAKf
 i8hXQa1NL4x3fm2ehh/ARougHOw6AqshBnIiMlo4DdhZa7SZRw
 06RDQ3JzjUDEXMbDV3AYA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aloha Mingming, Aloha Dave;

On the 29.07.2010 14:17, Dave Chinner wrote:
> On Wed, Jul 28, 2010 at 03:00:48PM -0700, Mingming Cao wrote:
>    
>> On Wed, 2010-07-28 at 01:38 +0200, Christian Stroetmann wrote:
>>      
>>> At the 28.07.2010 00:00, Ben Chociej wrote:
>>> Wouldn't this feature be useful for other file systems as well, so that
>>> a more general and not an only Btrfs related solution is preferable?
>>>
>>>        
>> Would certainly nice to add this feature to all filesystem, but right
>> now btrfs is the only fs which have multiple device support in itself.
>>      
>    

Thanks for your explanation, Mingming. And I had further questions to 
this point, but didn't know exactly how to formulate them in a short 
way. But luckily Dave has a possible solution that is related with my 
questions around the multiple device feature of Btrfs and hot data handling.

> Why does it even need multiple devices in the filesystem?

Yes, that was the point I asked myself after reading about this in the 
Btrfs wiki 
(https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices) 
and how ZFS does it.

>   All the
> filesystem needs to know is the relative speed of regions of it's
> block address space and to be provided allocation hints. everything
> else is just movement of data. You could keep the speed information
> in the device mapper table and add an interface for filesystems to
> query it, and then you've got infrastructure  that all filesystems
> could hook into.
>    

Yes indeed, something like this general solution that doesn't need the 
multiple device feature at all.

> The tracking features dont' appear to have anything btrfs specific
> in them, so t iseems wrong to implement it there just because you're
> only looking at btrfs' method of tracking multiple block devices
> and moving blocks....
>
> Cheers,
>
> Dave.
>    

Thank you very much for being creative. :D

Cheerio
Christian *<:o)   O>-<    -(D)>-<

