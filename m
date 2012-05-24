Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934135Ab2EXV4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:56:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:40417 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab2EXV4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:56:48 -0400
Message-ID: <1337896579.16119.2.camel@pasglop>
Subject: Re: [PATCH] vfio-powerpc: enabled and supported on power
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linux-kernel@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>, Alex Graf <agraf@suse.de>,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Date: Fri, 25 May 2012 07:56:19 +1000
In-Reply-To: <1337872323.4714.10.camel@ul30vt>
References: <4FBDA68B.30405@ozlabs.ru> <1337872323.4714.10.camel@ul30vt>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 09:12 -0600, Alex Williamson wrote:

> > --- /dev/null
> > +++ b/arch/powerpc/kernel/iommu_vfio.c
> 
> Should this be drivers/vfio/vfio_iommu_powerpc.c?

Very minor bike shed painting... too long file names suck, in
this case what's the point of the "vfio" prefix for files already
in the "vfio" directory ?

Cheers,
Ben.


