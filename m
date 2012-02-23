Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab2BWTuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:50:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486Ab2BWTuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:50:50 -0500
Date: Thu, 23 Feb 2012 21:50:54 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: RFC: export constants from shpc.h?
Message-ID: <20120223195053.GB28779@redhat.com>
References: <20120216145447.GA25979@redhat.com>
 <20120223085004.17e32327@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223085004.17e32327@jbarnes-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 08:50:04AM -0800, Jesse Barnes wrote:
> On Thu, 16 Feb 2012 16:54:49 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > I've implemented an shpc controller emulator
> > in qemu, so I needed a bunch of constants
> > similar to what drivers/pci/hotplug/shpc.h has.
> > 
> > Any objections to adding a PCI_SHPC_XXXX prefix
> > so these and moving them to pci_regs.h?
> > PCI utilities can then use them from /usr/include/linux.
> > 
> > One can see how a utility that looks at slot LED and MRL
> > states might be useful
> > (we'd need to export the base offset through sysfs
> > to make it possible to use such in parallel with shpc).
> 
> pci_regs.h is generally reserved for architected regs,
> but maybe a
> separate header file makes sense.  Or just patch libpciaccess or
> pci-utils with your tool.
> 
> -- 
> Jesse Barnes, Intel Open Source Technology Center

Fair enough, but out of curiosity,
could you pls clarify what is meant by 'architected'?
SHPC is a PCI-SIG spec after all, not a vecor-specific interface...


