Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415Ab0LNTDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 14:03:05 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:32680 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab0LNTDC (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 14 Dec 2010 14:03:02 -0500
Date: Tue, 14 Dec 2010 14:02:08 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 14 (xen)
Message-ID: <20101214190208.GA11901@dumpdata.com>
References: <20101214180723.3c70fdb9.sfr@canb.auug.org.au>
 <20101214100356.bdc5734e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214100356.bdc5734e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 10:03:56AM -0800, Randy Dunlap wrote:
> On Tue, 14 Dec 2010 18:07:23 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > [The mirroring on kernel.org is being slow again ...]
> > 
> > Changes since 20101213:
> 
> 
> linux-next-20101214/arch/x86/pci/xen.c:451: error: redefinition of 'xen_find_device_domain_owner'
> linux-next-20101214/arch/x86/include/asm/xen/pci.h:25: note: previous definition of 'xen_find_device_domain_owner' was here
> linux-next-20101214/arch/x86/pci/xen.c:465: error: redefinition of 'xen_register_device_domain_owner'
> linux-next-20101214/arch/x86/include/asm/xen/pci.h:29: note: previous definition of 'xen_register_device_domain_owner' was here
> linux-next-20101214/arch/x86/pci/xen.c:487: error: redefinition of 'xen_unregister_device_domain_owner'
> linux-next-20101214/arch/x86/include/asm/xen/pci.h:34: note: previous definition of 'xen_unregister_device_domain_owner' was here
> 

Fixed in the branch. Thank you for finding this.
