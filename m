Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab2FOIqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 04:46:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab2FOIqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 04:46:13 -0400
Date: Fri, 15 Jun 2012 09:46:00 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: build failure in Linus' tree
Message-ID: <20120615084600.GA663@amd.home.annexia.org>
References: <20120614114722.0fd16fb906b6a5503cfbc51a@canb.auug.org.au>
 <20120614030606.GC27673@linux-sh.org>
 <20120614034036.GE27673@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614034036.GE27673@linux-sh.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 12:40:36PM +0900, Paul Mundt wrote:
> Ok, it's because the asm-generic/bug.h __ASSEMBLY__ guarding is
> completely bogus. This should hopefully fix it once and for all.
> Sorry for the trouble.

I can confirm this fixes the build on ppc64 for me too.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-p2v converts physical machines to virtual machines.  Boot with a
live CD or over the network (PXE) and turn machines into Xen guests.
http://et.redhat.com/~rjones/virt-p2v
