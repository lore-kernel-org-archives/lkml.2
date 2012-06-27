Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab2F0Jzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:55:35 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:9881
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753538Ab2F0Jze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:55:34 -0400
X-Forefront-Antispam-Report: CIP:157.55.49.13;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0802HT009.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: PS-3(zzbb2dI98dI1432Izz1202hzz8275bhz2fh2a8h668h839hd25he5bhf0ah)
Message-ID: <4FEAD887.1080504@ozmodevices.com>
Date: Wed, 27 Jun 2012 10:55:19 +0100
From: Rupesh Gujare <rgujare@ozmodevices.com>
Organization: Ozmo Devices
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] staging: ozwpan: Fix compilation issue due to export.h
References: <1340712221-6750-1-git-send-email-rgujare@ozmodevices.com> <1340712221-6750-3-git-send-email-rgujare@ozmodevices.com> <20120626220732.GA21906@kroah.com>
In-Reply-To: <20120626220732.GA21906@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.149.82.179]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/06/12 23:07, Greg KH wrote:
> On Tue, Jun 26, 2012 at 01:03:40PM +0100, Rupesh Gujare wrote:
>> Fixes compilation error caused due to header file.
>>
>> Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>
>> ---
>>   drivers/staging/ozwpan/ozhcd.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
>> index 251f07c..e3efa41 100644
>> --- a/drivers/staging/ozwpan/ozhcd.c
>> +++ b/drivers/staging/ozwpan/ozhcd.c
>> @@ -28,7 +28,7 @@
>>   #include <linux/usb.h>
>>   #include <linux/jiffies.h>
>>   #include <linux/slab.h>
>> -#include <linux/export.h>
>> +#include <linux/module.h>
> I don't understand, what is this fixing?  It builds for me ok here, why
> is module.h needed instead of export.h?
>
> confused,
>
Greg,

Sorry about that. Looks like I tried to compile against distribution 
kernel, which was throwing error.
Please ignore this patch.

-- 
Regards,
Rupesh Gujare


