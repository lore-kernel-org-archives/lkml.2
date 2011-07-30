Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab1G3VbR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 17:31:17 -0400
Received: from mta31.charter.net ([216.33.127.82]:48047 "EHLO
	mta31.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab1G3VbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 17:31:12 -0400
X-Authority-Analysis: v=1.1 cv=9p7SjTZeSDUoepfMOc4Nsety+m2Qz47GaesuhdPPf9o=
 c=1 sm=1 a=_PlU6wiDepAA:10 a=ouLsrW8xN78A:10 a=Q9fys5e9bTEA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=ahY4YhYl6793SaG29C0A:9 a=PUjeQqilurYA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4E347824.9080207@cuw.edu>
Date: Sat, 30 Jul 2011 16:31:16 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        jpiszcz@lucidpixels.com
Subject: Re: [PATCH] uvcvideo: correct kernel version reference
References: <alpine.DEB.2.02.1107301020220.4925@p34.internal.lan> <1312040850-21475-1-git-send-email-Gregory.Dietsche@cuw.edu> <201107302236.13354.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201107302236.13354.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/30/2011 03:36 PM, Laurent Pinchart wrote:
> Hi Greg,
>
> Thanks for the patch.
>
> On Saturday 30 July 2011 17:47:30 Greg Dietsche wrote:
>    
>> change from v2.6.42 to v3.2
>>      
> This patch would be queued for v3.2. As the code it fixes will go away at the
> same time, it would be pretty pointless to apply it :-) Thanks for warning me
> though.
>
>    
you're welcome - I thought the merge window was still open for 3.1 ... 
so that's why I sent it in.

Greg

