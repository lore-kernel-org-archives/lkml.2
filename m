Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab0EaROr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 13:14:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab0EaROq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 13:14:46 -0400
Date: Mon, 31 May 2010 20:10:07 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Tom Lyon <pugs@cisco.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, chrisw@sous-sol.org, joro@8bytes.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100531171007.GA6516@redhat.com>
References: <4c004cba.Z/2Hpd7reetFaFC5%pugs@cisco.com> <20100530121944.GH27611@redhat.com> <4C025999.7080706@redhat.com> <20100530124949.GI27611@redhat.com> <4C0261C1.9090204@redhat.com> <20100530130332.GM27611@redhat.com> <4C026497.8070901@redhat.com> <20100530145309.GO27611@redhat.com> <4C03A285.7060902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C03A285.7060902@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 02:50:29PM +0300, Avi Kivity wrote:
> On 05/30/2010 05:53 PM, Michael S. Tsirkin wrote:
>>
>> So what I suggested is failing any kind of access until iommu
>> is assigned.
>>    
>
> So, the kernel driver must be aware of the iommu.  In which case it may  
> as well program it.

It's a kernel driver anyway. Point is that
the *device* driver is better off not programming iommu,
this way we do not need to reprogram it for each device.

> -- 
> I have a truly marvellous patch that fixes the bug which this
> signature is too narrow to contain.
