Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab0FILFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 07:05:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab0FILFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 07:05:15 -0400
Message-ID: <4C0F7555.6050802@redhat.com>
Date: Wed, 09 Jun 2010 14:04:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tom Lyon <pugs@cisco.com>
CC: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de, mst@redhat.com,
       gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
In-Reply-To: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2010 12:21 AM, Tom Lyon wrote:
> The VFIO "driver" is used to allow privileged AND non-privileged processes to
> implement user-level device drivers for any well-behaved PCI, PCI-X, and PCIe
> devices.
> 	Signed-off-by: Tom Lyon<pugs@cisco.com>
> ---
> This version now requires an IOMMU domain to be set before any access to
> device registers is granted (except that config space may be read).  In
> addition, the VFIO_DMA_MAP_ANYWHERE is dropped - it used the dma_map_sg API
> which does not have sufficient controls around IOMMU usage.  The IOMMU domain
> is obtained from the 'uiommu' driver which is included in this patch.
>
> Various locking, security, and documentation issues have also been fixed.
>
> Please commit - it or me!
> But seriously, who gets to commit this? Avi for KVM?

Definitely not me.

> or GregKH for drivers?
>    

I guess.

-- 
error compiling committee.c: too many arguments to function

