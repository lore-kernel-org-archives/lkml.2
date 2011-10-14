Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab1JNOXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:23:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:53364 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933015Ab1JNOXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:23:07 -0400
Date: Fri, 14 Oct 2011 10:22:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/21] pci: drop unused Kconfig symbol
Message-ID: <20111014142254.GA8887@phenom.oracle.com>
References: <1318595439.6132.77.camel@x61.thuisdomein>
 <20111014135743.GD4577@phenom.oracle.com>
 <1318601485.6132.91.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318601485.6132.91.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E9845C8.0150:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 04:11:25PM +0200, Paul Bolle wrote:
> On Fri, 2011-10-14 at 09:57 -0400, Konrad Rzeszutek Wilk wrote:
> > Can you provide a commit message describing why?
> 
> I'm afraid there's not much more to be said than I did in the summary:
> this drops an unused Kconfig symbol. 

Why? Is it b/c PCI_DEBUG does not exist? How did you determine it is
unused?

> 
> > And can you also use scripts/get_maintainer.pl in the future
> > to copy the maintainer of this driver as well?

Driver, not Kconfig.
> 
> I actually did:
> $ git format-patch --stdout -1 ec9f7a5 | scripts/get_maintainer.pl 
> Jesse Barnes <jbarnes@virtuousgeek.org> (supporter:PCI SUBSYSTEM)
> linux-pci@vger.kernel.org (open list:PCI SUBSYSTEM)
> linux-kernel@vger.kernel.org (open list)

konrad@phenom:~/work/linux$ scripts/get_maintainer.pl -f drivers/pci/xen-pcifront.c 
Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com> (supporter:XEN HYPERVISOR IN...)
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> (supporter:XEN HYPERVISOR IN...)
Jesse Barnes <jbarnes@virtuousgeek.org> (supporter:PCI SUBSYSTEM)
xen-devel@lists.xensource.com (open list:XEN HYPERVISOR IN...)
virtualization@lists.linux-foundation.org (open list:XEN HYPERVISOR IN...)
linux-pci@vger.kernel.org (open list:PCI SUBSYSTEM)
linux-kernel@vger.kernel.org (open list)
