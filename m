Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587Ab1FBDGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 23:06:50 -0400
Received: from trent.utfs.org ([194.246.123.103]:45869 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759290Ab1FBDGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 23:06:49 -0400
Date: Wed, 1 Jun 2011 20:06:46 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linville@tuxdriver.com, LKML <linux-kernel@vger.kernel.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>, zajec5@gmail.com
Subject: Re: 3.0-rc1: powerpc hangs at Kernel virtual memory layout
In-Reply-To: <1306983467.29297.51.camel@pasglop>
Message-ID: <alpine.DEB.2.01.1106012003370.21697@trent.utfs.org>
References: <alpine.DEB.2.01.1105311644010.21697@trent.utfs.org>  <alpine.DEB.2.01.1106011712270.21697@trent.utfs.org> <1306983467.29297.51.camel@pasglop>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jun 2011 at 12:57, Benjamin Herrenschmidt wrote:
> Ok, thanks a lot, It looks rather trivial actually: That new workaround
> is PCIe specific but is called unconditionally, and will do bad things
> non-PCIe implementations.

Indeed. This PowerBook G4 does not has PCIe, yet the whole SSB thingy gets 
enabled in my .config somehow. Thanks for the quick fix, I tried to revert 
ccc7c28af2... from Linus' current tree, but I had to rip out some more to 
make it compile.

I'll try your fix in a minute and get back to you with those cdrom init 
problems as well.

Thanks,
Christian.
-- 
BOFH excuse #166:

/pub/lunch
