Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab0EYRXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 13:23:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38368 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab0EYRXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 13:23:20 -0400
Message-ID: <4BFC0785.5010409@oracle.com>
Date: Tue, 25 May 2010 10:23:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-rdma@vger.kernel.org
Subject: Re: linux-next: Tree for May 25 (infiniband/hw/qib)
References: <20100525142657.c2ae7804.sfr@canb.auug.org.au>
In-Reply-To: <20100525142657.c2ae7804.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090206.4BFC0784.022E:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> We are in the merge window again.  I remind you all not to add stuff for
> 2.6.36 to your linux-next trees until after 2.6.35-rc1.
> 
> Changes since 20100524:


when CONFIG_PCI_MSI is not enabled:

ERROR: "qib_init_iba6120_funcs" [drivers/infiniband/hw/qib/ib_qib.ko] undefined!



fwiw, I would make building iba6120 support dependent on PCI_MSI
(i.e., change Kconfig), remove all of the PCI_MSI ifdef-ery
in qib_iba6120.c, and add a printk or 2 in qib_init for unsupported
devices.
