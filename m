Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab1ANKN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 05:13:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684Ab1ANKNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 05:13:10 -0500
Date: Fri, 14 Jan 2011 12:12:46 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Billy Rafferty <billy.rafferty@gmail.com>
Cc: linux-kernel@vger.kernel.org, hjk@hansjkoch.de
Subject: Re: uio_pci_generic has no mapping?
Message-ID: <20110114101246.GA1158@redhat.com>
References: <AANLkTi=bDV52-Fc22amAEsxofL7gRC=oaU+AXgUnuRt7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=bDV52-Fc22amAEsxofL7gRC=oaU+AXgUnuRt7@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 09:52:45AM +0000, Billy Rafferty wrote:
> Hi there,
> 
> I was hoping that someone might be be able to help me out using the
> uio_pci_generic driver.
> 
> To gain access to the memory in the card I try to do an mmap but it
> returns an error.
> 
> I was wondering if the mapping of the PCI memory regions is automatic?
>  I am not seeing /sys/class/uio/uio0/maps
> 
> Do I have to do something to get these to appear?
> 
> I would appreciate any help or pointers that you can give.
> 
> Regards,
> 
> Billy

mmap the pci resource through
/sys/class/uio/uio0/device/resourceX

The list of resources is in
/sys/class/uio/uio0/device/resource

-- 
MST
