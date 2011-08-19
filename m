Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1HSNUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:20:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab1HSNUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:20:45 -0400
Date: Fri, 19 Aug 2011 09:20:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Simon Horman <horms@verge.net.au>, oomichi@mxs.nes.nec.co.jp,
        linux-s390@vger.kernel.org, mahesh@linux.vnet.ibm.com,
        heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org,
        hbabu@us.ibm.com, ebiederm@xmission.com, schwidefsky@de.ibm.com,
        kexec@lists.infradead.org
Subject: Re: [patch 0/3] kdump: Add external kdump entry point for s390
 stand-alone dump tools
Message-ID: <20110819132019.GA18656@redhat.com>
References: <20110729123944.562622201@linux.vnet.ibm.com>
 <20110819011431.GB20747@verge.net.au>
 <1313758400.3858.12.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313758400.3858.12.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 02:53:20PM +0200, Michael Holzheu wrote:

[...]
> > although I am a little unclear about the status of the kernel side of
> > things. Please let me know if you would like me to merge the kexec-tools
> > patches now or wait a bit (for an updated version?).
> 
> I think that we are almost done with the discussion. I will send you my
> current kexec-tools patches and would be glad, if you could integrate
> them now.

I guess kexec-tools integration will make more sense once kernel patches
show up atleast in one maintainer's subtree.

Also in kernel patches, atleast we need to resolve the issue of arch
specific kmap(), kunmap() calls so that we don't have to make
kimage_load_crash_segment() arch specific.

Thanks
Vivek
