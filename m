Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab0FBJuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:50:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757675Ab0FBJus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:50:48 -0400
Message-ID: <4C062957.5030801@redhat.com>
Date: Wed, 02 Jun 2010 12:50:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
References: <4C025999.7080706@redhat.com> <20100530124949.GI27611@redhat.com> <4C0261C1.9090204@redhat.com> <20100530130332.GM27611@redhat.com> <4C026497.8070901@redhat.com> <20100530145309.GO27611@redhat.com> <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com> <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com> <20100602094201.GC964@8bytes.org>
In-Reply-To: <20100602094201.GC964@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 12:42 PM, Joerg Roedel wrote:
> On Tue, Jun 01, 2010 at 12:55:32PM +0300, Michael S. Tsirkin wrote:
>
>    
>> There seems to be some misunderstanding.  The userspace interface
>> proposed forces a separate domain per device and forces userspace to
>> repeat iommu programming for each device.  We are better off sharing a
>> domain between devices and programming the iommu once.
>>
>> The natural way to do this is to have an iommu driver for programming
>> iommu.
>>      
> IMO a seperate iommu-userspace driver is a nightmare for a userspace
> interface. It is just too complicated to use. We can solve the problem
> of multiple devices-per-domain with an ioctl which allows binding one
> uio-device to the address-space on another. Thats much simpler.
>    

This is non trivial with hotplug.

-- 
error compiling committee.c: too many arguments to function

