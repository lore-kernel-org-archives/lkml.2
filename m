Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1BOQ7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:59:33 -0500
Received: from smtp.microsoft.com ([131.107.115.215]:46614 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab1BOQ7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:59:30 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        Hashir Abdi <habdi@microsoft.com>,
        "Mike Sterling" <Mike.Sterling@microsoft.com>
Subject: RE: [PATCH ]:Staging: hv: Allocate the vmbus irq dynamically
Thread-Topic: [PATCH ]:Staging: hv: Allocate the vmbus irq dynamically
Thread-Index: AQHLzSIS6znEnyFqNE6ccb9lSMyu/JQDPp0AgAAPB4D//3rkwA==
Date: Tue, 15 Feb 2011 16:59:28 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56233F9714A@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <1297782937-24082-1-git-send-email-kys@microsoft.com>
 <20110215155954.GA32313@suse.de>
 <FB42D5CCD7B5934EB1827DB5ED9B850E07085DA1@TK5EX14MBXC104.redmond.corp.microsoft.com>
In-Reply-To: <FB42D5CCD7B5934EB1827DB5ED9B850E07085DA1@TK5EX14MBXC104.redmond.corp.microsoft.com>
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
> From: KY Srinivasan
> Sent: Tuesday, February 15, 2011 8:54 AM
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@suse.de]
> > Sent: Tuesday, February 15, 2011 11:00 AM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > virtualization@lists.osdl.org; Haiyang Zhang; Hank Janssen
> > Subject: Re: [PATCH ]:Staging: hv: Allocate the vmbus irq dynamically
> >

> > And why are you still printing this out for the whole world to see?
> Greg, this patch addressed a specific comment with regards dynamically
> allocate the irq.
> Hank is working on a patch to address the various DPRINTS in the code.

Before the end of the week I will submit two patches for this;

	Remove DPRINT and change it to printk
	Remove excessive printouts on startup of vmbus

Hank.

