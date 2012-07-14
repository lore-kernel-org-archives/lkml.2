Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab2GNOfN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 10:35:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:30939 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389Ab2GNOfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 10:35:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="177324168"
Date: Sat, 14 Jul 2012 22:34:59 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel boot hangs on commit "switch fput to task_work_add"
Message-ID: <20120714143459.GA1544@localhost>
References: <20120710141830.GA5385@localhost>
 <20120714130510.GC31729@ZenIV.linux.org.uk>
 <20120714134849.GA1175@localhost>
 <20120714135849.GA1257@localhost>
 <20120714141415.GD31729@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120714141415.GD31729@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 03:14:15PM +0100, Al Viro wrote:
> On Sat, Jul 14, 2012 at 09:58:49PM +0800, Fengguang Wu wrote:
> > > Hi Al, here I got the output for
> > > 
> > > (qemu) sendkey alt-sysrq-l
> > > (qemu) sendkey alt-sysrq-t
> > 
> > I repeated that several times and here are the results.
> > 
> > (qemu) sendkey alt-sysrq-l
> > (qemu) sendkey alt-sysrq-l
> > (qemu) sendkey alt-sysrq-l
> > (qemu) sendkey alt-sysrq-t
> > (qemu) sendkey alt-sysrq-t
> > (qemu) quit
> > 
> > The user space shutdown is polling on something, which prevents the
> > system from reboot..
> 
> Which userland it is?

It's a customized ubuntu core. The original tgz image is downloaded
here, however it's not directly usable as initrd.. Should I send my
hacked one?

24M     quantal-core-x86_64.cgz

http://cdimage.ubuntu.com/ubuntu-core/releases/quantal/alpha-2/

Thanks,
Fengguang
