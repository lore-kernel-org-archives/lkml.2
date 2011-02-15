Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab1BOR2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:28:35 -0500
Received: from smtp.microsoft.com ([131.107.115.215]:14507 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab1BOR2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:28:34 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hashir Abdi <habdi@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>
Subject: RE: [PATCH ]:Staging: hv: Allocate the vmbus irq dynamically
Thread-Topic: [PATCH ]:Staging: hv: Allocate the vmbus irq dynamically
Thread-Index: AQHLzSIS6znEnyFqNE6ccb9lSMyu/JQDPp0AgAAPB4D//3rkwIAAjUSA//97LcA=
Date: Tue, 15 Feb 2011 17:28:32 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56233F97247@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <1297782937-24082-1-git-send-email-kys@microsoft.com>
 <20110215155954.GA32313@suse.de>
 <FB42D5CCD7B5934EB1827DB5ED9B850E07085DA1@TK5EX14MBXC104.redmond.corp.microsoft.com>
 <8AFC7968D54FB448A30D8F38F259C56233F9714A@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20110215172253.GB18437@suse.de>
In-Reply-To: <20110215172253.GB18437@suse.de>
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
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Tuesday, February 15, 2011 9:23 AM
> > Before the end of the week I will submit two patches for this;
> >
> > 	Remove DPRINT and change it to printk
> 
> No, use dev_dbg() and friends instead of "raw" printk() calls.
> 

Will do, you caught me just as I was starting the conversion :)

> > 	Remove excessive printouts on startup of vmbus
> 
> That would be nice to see.  There should be almost nothing outputed by
> these drivers on "normal" operation.

Agreed.

Hank.
