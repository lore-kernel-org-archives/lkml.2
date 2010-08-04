Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab0HDSkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:40:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65104 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab0HDSkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:40:08 -0400
Message-ID: <4C59B4F2.5050404@ontolinux.com>
Date: Wed, 04 Aug 2010 20:44:02 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Mingming Cao <cmm@us.ibm.com>
CC: Ben Chociej <bchociej@gmail.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Btrfs: Add hot data tracking functionality
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com>	 <4C4F6DF2.6090905@ontolinux.com> <1280354448.7694.4.camel@mingming-laptop>	 <20100729121729.GK655@dastard> <1280943620.4676.65.camel@mingming-laptop>
In-Reply-To: <1280943620.4676.65.camel@mingming-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:KVBT8E5pO3+3aMYvJmYlX1ahLBCwSP3oozWTWKBeEvW
 n7ZJ3P6w0Sb+SDSqusfEoRCwRfduSBfG5SDH66rKkrOxJIpctg
 inV3QTVaUqecLrqB4Zn5o0yOozkwnM4joW4wW+8LQFiSzXUyjy
 eH+NjQlUstSskpyZ7OTvzP+J7TOxYFFQt1LEeWa6iODeaeqX4I
 xyqQA+CY9WJYcTEdjJEhw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hola Everybody;
On the 04.08.2010 19:40, Mingming Cao wrote:
> On Thu, 2010-07-29 at 22:17 +1000, Dave Chinner wrote:
>    
>> On Wed, Jul 28, 2010 at 03:00:48PM -0700, Mingming Cao wrote:
>>      
>>> On Wed, 2010-07-28 at 01:38 +0200, Christian Stroetmann wrote:
>>>        
>>>> At the 28.07.2010 00:00, Ben Chociej wrote:
>>>> Wouldn't this feature be useful for other file systems as well, so that
>>>> a more general and not an only Btrfs related solution is preferable?
>>>>
>>>>          
>>> Would certainly nice to add this feature to all filesystem, but right
>>> now btrfs is the only fs which have multiple device support in itself.
>>>        
>> Why does it even need multiple devices in the filesystem? All the
>> filesystem needs to know is the relative speed of regions of it's
>> block address space and to be provided allocation hints. everything
>> else is just movement of data. You could keep the speed information
>> in the device mapper table and add an interface for filesystems to
>> query it, and then you've got infrastructure  that all filesystems
>> could hook into.
>>
>> The tracking features dont' appear to have anything btrfs specific
>> in them, so t iseems wrong to implement it there just because you're
>> only looking at btrfs' method of tracking multiple block devices
>> and moving blocks....
>>
>>      
>
> I agree hot data tracking could be done at vfs layer. The current hot
> data temperature calculation and indexing code is very self-contained,
> and could be reuse to other fs or move up to vfs. We could define a
> common interface to export to hot data tempreture out. The relocation
> eventually has to be filesystem specific. btrfs does cow and knows where
> is the data on/off SSD directly makes the relocation to and from very
> straightforward.
>
>    

Thanks for your thumb up. But maybe other interested persons should also 
point their thumbs up at first before investing the effort of its 
implementation. I mentioned this feature, because it is a trend that got 
momentum in the area of (storage) virtualization and in this way in the 
fields of cloud computing and service computing as well.

And: My both thumbs are already up. :D

> Mingming
>
>    

Christian *<:o)   O>-<    -(D)>-<
