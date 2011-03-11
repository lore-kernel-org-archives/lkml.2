Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab1CKCJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 21:09:19 -0500
Received: from mailc.microsoft.com ([131.107.115.214]:49516 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab1CKCJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 21:09:18 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Hank Janssen <hjanssen@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Mike Sterling" <Mike.Sterling@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: RE: [PATCH 12/21] Staging: hv: Cleanup irq management
Thread-Topic: [PATCH 12/21] Staging: hv: Cleanup irq management
Thread-Index: AQHL325oF0iGwgacC0me7/v84Jbl85QnsSMAgAACSwD//6+s8A==
Date: Fri, 11 Mar 2011 02:09:15 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048018B3E@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
 <1299794933-1259-1-git-send-email-kys@microsoft.com>,<alpine.LFD.2.00.1103102338230.2787@localhost6.localdomain6>
 <E2765C4D-2B98-4D06-8007-3416952F19FD@microsoft.com>
In-Reply-To: <E2765C4D-2B98-4D06-8007-3416952F19FD@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Hank Janssen
> Sent: Thursday, March 10, 2011 5:54 PM
> To: Thomas Gleixner
> Cc: KY Srinivasan; gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang; Mike
> Sterling; Abhishek Kane (Mindtree Consulting PVT LTD)
> Subject: Re: [PATCH 12/21] Staging: hv: Cleanup irq management
> 
> 
> 
> 
> 
> 
> On Mar 10, 2011, at 14:46, "Thomas Gleixner" <tglx@linutronix.de> wrote:
> >>
> >
> >>    }
> >> -    vector = VMBUS_IRQ_VECTOR;
> >>
> >> -    DPRINT_INFO(VMBUS_DRV, "irq 0x%x vector 0x%x", vmbus_irq, vector);
> >> +    vector = IRQ0_VECTOR + pdev->irq;
> >> +    DPRINT_INFO(VMBUS_DRV, "irq 0x%x vector 0x%x", pdev->irq,
> >> +            IRQ0_VECTOR + pdev->irq);
> >
> > Why evaluating vector first and then not using it for that debug print
> > thingy?
Good point; I will fix this before Hank gets rid of the DPRINT_INFO altogether.

Regards,

K. Y

