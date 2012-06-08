Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761973Ab2FHQTC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:19:02 -0400
Received: from mout2.freenet.de ([195.4.92.92]:45378 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761349Ab2FHQTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:19:00 -0400
Message-ID: <4FD22552.6090609@01019freenet.de>
Date: Fri, 08 Jun 2012 18:16:18 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120428 Firefox/12.0 SeaMonkey/2.9.1
MIME-Version: 1.0
To: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
References: <1339156616.3870.9.camel@blech>  <20120608130351.GB1964@redhat.com> <4FD1FB49.3020905@siemens.com>  <1339165009.26976.60.camel@ul30vt> <1339166867.3870.29.camel@blech>
In-Reply-To: <1339166867.3870.29.camel@blech>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dominic,

Dominic Eschweiler wrote:
> Am Freitag, den 08.06.2012, 08:16 -0600 schrieb Alex Williamson:
>> Yes, thanks Jan.  This is exactly what VFIO does.  VFIO provides
>> secure config space access, resource access, DMA mapping services, and
>> full interrupt support to userspace.  
> 
> I know about VFIO, but we need some support for that stuff relatively
> soon. That's the reason why I'm currently working on it to make UIO DMA
> capable. My extensions probably do not play well with IOMMUs and they
> therefore won't make it to mainline anyhow (i learned that today ;-).

I'm not sure if vfio covers your needs completely, but I tested it here
very successfully. I was able to create a patch, which can be applied to
opensuse 3.4.1 kernel and which seams to run well.

I even managed to integrate it into libvirt :-). So it is usable as
every other traditional VM, too.

Besides the problem with AMD IOMMU, which requires to unbind a whole
group of devices in some cases (PCI passthrough - not PCIe), it's really
cool! And it's usable now!


Regards,
Andreas
