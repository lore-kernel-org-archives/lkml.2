Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab2KUR0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:26:22 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:5680
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754470Ab2KUR0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:26:21 -0500
X-Forefront-Antispam-Report: CIP:157.56.245.149;KIP:(null);UIP:(null);IPV:NLI;H:CH1PRD0810HT003.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: PS-3(zzbb2dI98dI1432Izz1de0h1202h1d1ah1d2ahzzz2fh2a8h668h839hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
Message-ID: <50AD0EB4.5070307@ozmodevices.com>
Date: Wed, 21 Nov 2012 17:26:12 +0000
From: Rupesh Gujare <rgujare@ozmodevices.com>
Organization: Ozmo Devices
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <devel@driverdev.osuosl.org>, <sachin.kamat@linaro.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [V2 PATCH 1/3] staging: ozwpan: Remove redundant null check before
 kfree in ozpd.c
References: <20121120163513.GC4990@kroah.com> <1353501977-6585-2-git-send-email-rgujare@ozmodevices.com> <20121121130527.GH11248@mwanda> <50ACDA54.7040508@ozmodevices.com> <20121121161859.GI6186@mwanda>
In-Reply-To: <20121121161859.GI6186@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.149.82.179]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/11/12 16:19, Dan Carpenter wrote:
> When someone sends a patch there are a several possible responses:
> 1) Ack the patch.
> 2) Request that the submitter redo it.  The downside is that no one
>     likes redoing patches.
> 3) Reject the patch.
> 4) Redo it yourself and say "Based on a patch from Sachin Kamat".
>     This isn't nice because everyone wants author credit.
> 5) Redo it and get permission from the original author to give them
>     author credit get their signed-off-by.
>
>
Thanks Dan

I will keep it in mind in future.

Sachin,

Are you interested in redoing (or sending sign-off ?) for this patch 
series ? I am more than happy to accept either.

-- 
Regards,
Rupesh Gujare


