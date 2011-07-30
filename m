Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab1G3ViW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 17:38:22 -0400
Received: from mta11.charter.net ([216.33.127.80]:53371 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1G3ViQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 17:38:16 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jul 2011 17:38:15 EDT
X-Authority-Analysis: v=1.1 cv=9p7SjTZeSDUoepfMOc4Nsety+m2Qz47GaesuhdPPf9o=
 c=1 sm=1 a=_PlU6wiDepAA:10 a=ouLsrW8xN78A:10 a=Q9fys5e9bTEA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=2Q1i--T3G9GxwS85VTgA:9 a=PUjeQqilurYA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4E3479CC.7040403@cuw.edu>
Date: Sat, 30 Jul 2011 16:38:20 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        jpiszcz@lucidpixels.com
Subject: Re: [PATCH] uvcvideo: correct kernel version reference
References: <alpine.DEB.2.02.1107301020220.4925@p34.internal.lan> <201107302236.13354.laurent.pinchart@ideasonboard.com> <4E347824.9080207@cuw.edu> <201107302334.38723.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201107302334.38723.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/30/2011 04:34 PM, Laurent Pinchart wrote:
> Hi Greg,
>
> On Saturday 30 July 2011 23:31:16 Greg Dietsche wrote:
>    
>> On 07/30/2011 03:36 PM, Laurent Pinchart wrote:
>>      
>>> Hi Greg,
>>>
>>> Thanks for the patch.
>>>
>>> On Saturday 30 July 2011 17:47:30 Greg Dietsche wrote:
>>>        
>>>> change from v2.6.42 to v3.2
>>>>          
>>> This patch would be queued for v3.2. As the code it fixes will go away at
>>> the same time, it would be pretty pointless to apply it :-) Thanks for
>>> warning me though.
>>>        
>> you're welcome - I thought the merge window was still open for 3.1 ...
>> so that's why I sent it in.
>>      
> Linus' merge window is still open, but this will have to go through Mauro's
> tree, and it won't make it on time.
>
>    
Ah, that makes sense :) Anyway it is very trivial...

thanks for the explanation!

Greg
