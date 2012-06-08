Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934387Ab2FHQ7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:59:25 -0400
Received: from thoth.sbs.de ([192.35.17.2]:18597 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760669Ab2FHQ7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:59:23 -0400
Message-ID: <4FD22F62.3070905@siemens.com>
Date: Fri, 08 Jun 2012 18:59:14 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@hansjkoch.de>
CC: Andreas Hartmann <andihartmann@01019freenet.de>,
        Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
References: <1339156616.3870.9.camel@blech> <20120608130351.GB1964@redhat.com> <4FD1FB49.3020905@siemens.com> <1339165009.26976.60.camel@ul30vt> <1339166867.3870.29.camel@blech> <4FD22552.6090609@01019freenet.de> <20120608164426.GE9705@local>
In-Reply-To: <20120608164426.GE9705@local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-08 18:44, Hans J. Koch wrote:
> On Fri, Jun 08, 2012 at 06:16:18PM +0200, Andreas Hartmann wrote:
>> Hi Dominic,
>>
>> Dominic Eschweiler wrote:
>>> Am Freitag, den 08.06.2012, 08:16 -0600 schrieb Alex Williamson:
>>>> Yes, thanks Jan.  This is exactly what VFIO does.  VFIO provides
>>>> secure config space access, resource access, DMA mapping services, and
>>>> full interrupt support to userspace.  
> 
> VFIO is not a "better UIO". It *requires* an IOMMU. Dominic didn't say on
> what CPU he's working, so it's not clear if he can use VFIO at all.
> 
> UIO is intended for general use with devices that have mappable registers
> and don't fit into any other subsystem. No more, no less.

Maybe it is worth mentioning in the docs that UIO cannot support DMA,
thus bus master mode. Apparently people do not realize this constraint
and expect more of it than it is supposed to deliver.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
