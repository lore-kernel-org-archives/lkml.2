Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab2HYPml (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 11:42:41 -0400
Received: from smtp1.uu.se ([130.238.7.54]:33449 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372Ab2HYPmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 11:42:39 -0400
X-Spam-Flag: NO
X-Spam-Score: -3.835
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20536.61972.508189.308675@pilspetsen.it.uu.se>
Date: Sat, 25 Aug 2012 17:41:08 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org
Subject: Re: [3.6-rc3 regression] sata_mv cannot get optional clkdev breaking
 boot on QNAP TS-119P+
In-Reply-To: <20120825151524.GH9886@lunn.ch>
References: <20536.52397.140042.917795@pilspetsen.it.uu.se>
	<20120825151524.GH9886@lunn.ch>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Lunn writes:
 > On Sat, Aug 25, 2012 at 03:01:33PM +0200, Mikael Pettersson wrote:
 > > My Kirkwood-based QNAP TS-119P+ boots fine with the 3.5 kernel.  With
 > > 3.6-rc2 and 3.6-rc3 however sata_mv complains:
 > > 
 > > sata_mv sata_mv.0: cannot get optional clkdev
 > > sata_mv sata_mv.0: slots 32 ports 2
 > > 
 > > and then the kernel grinds to a halt with no further messages.
 > > 
 > > Full boot log from 3.6-rc3 appended below.  .config available upon
 > > request, but this is a non-DT kernel.
 > 
 > Hi Mikael
 > 
 > This is a known issue. See:
 > 
 > http://comments.gmane.org/gmane.linux.ports.arm.kernel/181989
 > 
 > There are patches being developed to fix this. I hope we can push them
 > to an RC soon.

Thanks for the pointer.  Aaro Koskinen's suggestion of passing
coherent_pool=1M to the kernel allowed it to boot successfully.
I'll use that workaround for now.

/Mikael
