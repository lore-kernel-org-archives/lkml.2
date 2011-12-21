Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab1LUGWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 01:22:22 -0500
Received: from mtv-iport-3.cisco.com ([173.36.130.14]:4407 "EHLO
	mtv-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab1LUGWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 01:22:05 -0500
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Dec 2011 01:22:05 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAOh38U6rRDoG/2dsb2JhbABDrBOBBYFyAQEBAwESAScCATwFDQEIEgZ3DgEBBAENBSKHWJkQAZ5CjA8EiDeMSJJT
X-IronPort-AV: E=Sophos;i="4.71,386,1320624000"; 
   d="scan'208";a="21834357"
User-Agent: Microsoft-Entourage/12.31.0.110725
Date: Tue, 20 Dec 2011 22:12:45 -0800
Subject: Re: [Qemu-devel] [RFC] Device isolation infrastructure v2
From: Aaron Fabbri <aafabbri@cisco.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
CC: <chrisw@redhat.com>, <aik@ozlabs.ru>, <rusty@rustcorp.com.au>,
        <agraf@suse.de>, <qemu-devel@nongnu.org>, <B08248@freescale.com>,
        <iommu@lists.linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <scottwood@freescale.com>, David Woodhouse <dwmw2@infradead.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <CB16B8DD.149D7%aafabbri@cisco.com>
Thread-Topic: [Qemu-devel] [RFC] Device isolation infrastructure v2
Thread-Index: Acy/p44ENvAnRiNFOEqu8CTE8+JJDA==
In-Reply-To: <1324441837.29699.38.camel@bling.home>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 21 Dec 2011 06:12:47.0081 (UTC) FILETIME=[8F41F590:01CCBFA7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On 12/20/11 8:30 PM, "Alex Williamson" <alex.williamson@redhat.com> wrote:

> On Wed, 2011-12-21 at 14:32 +1100, David Gibson wrote:
>> On Mon, Dec 19, 2011 at 04:41:56PM +0100, Joerg Roedel wrote:
>>> On Mon, Dec 19, 2011 at 11:11:25AM +1100, David Gibson wrote:
<snip>
>>> 
>>> Well, the iommu-api was designed for amd-vi and vt-d. But its concepts
>>> turn out to be more general and by no way x86-centric anymore.
>> 
>> It's improving, but there are still plenty of x86isms there.
> 
> Having worked on ia64 for a while, it's interesting to see this x86
> bashing from the other side.  Everyone is more than willing to make
> architecture neutral interfaces (jeez, look at the extent of the vfio
> reworks), but it's not fair to throw away interfaces as x86-centric if
> you're not pushing your requirements and making use of the code.
> 
> It seems like we'd be better served today to start with the vfio code we
> have and let that be the catalyst to drive an iommu api that better
> serves non-x86.  I don't see how this group management tangent is really
> getting us anywhere.  Thanks,

I'd agree that incremental approach here is key.  VFIO has already seen a
ton of rework to accommodate all architectures.  Let's not bite off a bunch
of these other subsystem rewrites in the same chunk as our VFIO effort.

-Aaron

