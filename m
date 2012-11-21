Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab2KUNnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:43:03 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:45954 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854Ab2KUNm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:42:59 -0500
X-Forefront-Antispam-Report: CIP:157.56.232.53;KIP:(null);UIP:(null);IPV:NLI;H:BLUPRD0811HT005.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: PS-3(zzbb2dI98dI1432Izz1de0h1202h1d1ah1d2ahzz8275bh8275dhz2fh2a8h668h839hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
Message-ID: <50ACDA54.7040508@ozmodevices.com>
Date: Wed, 21 Nov 2012 13:42:44 +0000
From: Rupesh Gujare <rgujare@ozmodevices.com>
Organization: Ozmo Devices
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <devel@driverdev.osuosl.org>, <sachin.kamat@linaro.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [V2 PATCH 1/3] staging: ozwpan: Remove redundant null check before
 kfree in ozpd.c
References: <20121120163513.GC4990@kroah.com> <1353501977-6585-2-git-send-email-rgujare@ozmodevices.com> <20121121130527.GH11248@mwanda>
In-Reply-To: <20121121130527.GH11248@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.149.82.179]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/11/12 13:05, Dan Carpenter wrote:
> On Wed, Nov 21, 2012 at 12:46:15PM +0000, Rupesh Gujare wrote:
>> Call kfree only if required else return from function.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>
> I'm not sure this is right.
>
> Signed-off-by is intended to have a legal meaning that you are
> signing off that you have permission to submit the patch.  You're
> not allowed to sign off on behalf of someone else.
>
> If we apply this as is, then you get the author credit.  If you want
> to give Sachin author credit then make the first line of the email:
>
> From: Sachin Kamat <sachin.kamat@linaro.org>

All right, thats my mistake. I did not understood "signed-off-by" 
properly  . All my intention was to acknowledge original author's 
contribution and make changes which are good for driver code. I am more 
than happy to resend this patch series if I am allowed to use someone 
else credentials (which I felt is wrong)

Please let me know what is a best way to do it.

>
> Also it's not a good idea to get too control freaky over this code
> which is all going to have to be replaced before this can graduate
> out of staging.  You're just going to discourage people from
> contributing if you redo all their patches.  Linaro people are the
> real deal and you should let them help.
>
>

Only intention to redo this patch series is that, new code implemented 
seems more logical to me. I welcome any criticism of code, & I am very 
much happy to accept any contributions, as done in past.


-- 
Regards,
Rupesh Gujare


