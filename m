Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab2KVSay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:30:54 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:3698 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752812Ab2KVSav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:30:51 -0500
X-Forefront-Antispam-Report: CIP:157.56.241.101;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0810HT003.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: PS-3(zzbb2dI98dI1432Izz1de0h1202h1d1ah1d2ahzz17326ah8275dhz2fh2a8h668h839hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
Message-ID: <50AD5F54.4070609@ozmodevices.com>
Date: Wed, 21 Nov 2012 23:10:12 +0000
From: Rupesh Gujare <rgujare@ozmodevices.com>
Organization: Ozmo Devices
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>, <devel@driverdev.osuosl.org>,
        <sachin.kamat@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [V2 PATCH 1/3] staging: ozwpan: Remove redundant null check before
 kfree in ozpd.c
References: <20121120163513.GC4990@kroah.com> <1353501977-6585-2-git-send-email-rgujare@ozmodevices.com> <20121121130527.GH11248@mwanda> <50ACDA54.7040508@ozmodevices.com> <20121121161859.GI6186@mwanda> <50AD0EB4.5070307@ozmodevices.com> <20121121214823.GA28532@kroah.com>
In-Reply-To: <20121121214823.GA28532@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [94.9.187.151]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/11/12 21:48, Greg KH wrote:
> On Wed, Nov 21, 2012 at 05:26:12PM +0000, Rupesh Gujare wrote:
>> On 21/11/12 16:19, Dan Carpenter wrote:
>>> When someone sends a patch there are a several possible responses:
>>> 1) Ack the patch.
>>> 2) Request that the submitter redo it.  The downside is that no one
>>>     likes redoing patches.
>>> 3) Reject the patch.
>>> 4) Redo it yourself and say "Based on a patch from Sachin Kamat".
>>>     This isn't nice because everyone wants author credit.
>>> 5) Redo it and get permission from the original author to give them
>>>     author credit get their signed-off-by.
>>>
>>>
>> Thanks Dan
>>
>> I will keep it in mind in future.
>>
>> Sachin,
>>
>> Are you interested in redoing (or sending sign-off ?) for this patch
>> series ? I am more than happy to accept either.
> Don't worry, I'll clean up the mess here...
>
>
Sorry Greg,

But looks like you applied V1 of this patch series, rather than V2. Is 
that intentional ?

Below is link for V2 :-

http://driverdev.linuxdriverproject.org/pipermail/devel/2012-November/033339.html

& yes, V2 is missing -

From: Sachin Kamat<sachin.kamat@linaro.org>



-- 
Regards,
Rupesh Gujare


