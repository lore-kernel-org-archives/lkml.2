Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab2JJWCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:02:06 -0400
Received: from adoakley.name ([46.4.104.242]:41845 "EHLO ado.is-a-geek.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756595Ab2JJWCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:02:03 -0400
Date: Wed, 10 Oct 2012 23:02:31 +0100
From: Andrew Oakley <andrew@ado.is-a-geek.net>
To: Andrew Oakley <andrew@ado.is-a-geek.net>
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] IOMMU Updates for v3.7-rc1
Message-ID: <20121010230231.2fb3c3b9@ado-amd-gentoo.moore.slainvet.net>
In-Reply-To: <20121010201131.091d5a1f@ado-amd-gentoo.moore.slainvet.net>
References: <20121005152312.GA4649@8bytes.org>
	<20121009224532.1e515664@ado-amd-gentoo.moore.slainvet.net>
	<20121010073022.GB16151@8bytes.org>
	<20121010095823.140fdd98@ado-amd-gentoo.moore.slainvet.net>
	<20121010133249.GC16151@8bytes.org>
	<20121010201131.091d5a1f@ado-amd-gentoo.moore.slainvet.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012 20:11:31 +0100
Andrew Oakley <andrew@ado.is-a-geek.net> wrote:
> If I modify the devid for the IOAPIC in init_iommu_from_acpi then it
> also seems to work.  I haven't managed to get vfio/qemu working yet
> but it seems to be unrelated ("Invalid ROM contents", same thing
> happens when I try to dump the rom with stable kernels).

I've now managed to get a network card passed through and working
properly in a guest.  The bug has been reported to the vendor so
hopefully it will get fixed in a BIOS update.

I'm not sure if the fix I've got is safe or if it's really a good idea
to enable interrupt remapping with a broken BIOS.

Thanks

-- 
Andrew Oakley
