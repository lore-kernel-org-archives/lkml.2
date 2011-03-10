Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1CJWyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:54:24 -0500
Received: from smtp.microsoft.com ([131.107.115.215]:21179 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1CJWyX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:54:23 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: KY Srinivasan <kys@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: Re: [PATCH 12/21] Staging: hv: Cleanup irq management
Thread-Topic: [PATCH 12/21] Staging: hv: Cleanup irq management
Thread-Index: AQHL325nOE0HAk4kpkSIXwDy6JM9S5QnsSMA//98Lsw=
Date: Thu, 10 Mar 2011 22:54:20 +0000
Message-ID: <E2765C4D-2B98-4D06-8007-3416952F19FD@microsoft.com>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
 <1299794933-1259-1-git-send-email-kys@microsoft.com>,<alpine.LFD.2.00.1103102338230.2787@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103102338230.2787@localhost6.localdomain6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org






On Mar 10, 2011, at 14:46, "Thomas Gleixner" <tglx@linutronix.de> wrote:
>> 
> 
>>    }
>> -    vector = VMBUS_IRQ_VECTOR;
>> 
>> -    DPRINT_INFO(VMBUS_DRV, "irq 0x%x vector 0x%x", vmbus_irq, vector);
>> +    vector = IRQ0_VECTOR + pdev->irq;
>> +    DPRINT_INFO(VMBUS_DRV, "irq 0x%x vector 0x%x", pdev->irq,
>> +            IRQ0_VECTOR + pdev->irq);
> 
> Why evaluating vector first and then not using it for that debug print
> thingy?
> 
> Btw, are you going to replace that DPRINT_* stuff as well ?
> 
> Thanks,
> 
>     

Yes, that is in my next set of patches. 

Hank
