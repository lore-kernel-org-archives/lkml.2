Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2HYPPt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 11:15:49 -0400
Received: from londo.lunn.ch ([80.238.139.98]:54114 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab2HYPPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 11:15:46 -0400
Date: Sat, 25 Aug 2012 17:15:24 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [3.6-rc3 regression] sata_mv cannot get optional clkdev breaking
 boot on QNAP TS-119P+
Message-ID: <20120825151524.GH9886@lunn.ch>
References: <20536.52397.140042.917795@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20536.52397.140042.917795@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 03:01:33PM +0200, Mikael Pettersson wrote:
> My Kirkwood-based QNAP TS-119P+ boots fine with the 3.5 kernel.  With
> 3.6-rc2 and 3.6-rc3 however sata_mv complains:
> 
> sata_mv sata_mv.0: cannot get optional clkdev
> sata_mv sata_mv.0: slots 32 ports 2
> 
> and then the kernel grinds to a halt with no further messages.
> 
> Full boot log from 3.6-rc3 appended below.  .config available upon
> request, but this is a non-DT kernel.

Hi Mikael

This is a known issue. See:

http://comments.gmane.org/gmane.linux.ports.arm.kernel/181989

There are patches being developed to fix this. I hope we can push them
to an RC soon.

   Andrew
