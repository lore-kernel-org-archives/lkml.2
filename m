Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab2KGIf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 03:35:59 -0500
Received: from umail.aei.mpg.de ([194.94.224.6]:39778 "EHLO umail.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab2KGIf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 03:35:58 -0500
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2012 03:35:58 EST
Date: Wed, 7 Nov 2012 09:28:20 +0100
From: Steffen Grunewald <Steffen.Grunewald@aei.mpg.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: htejun@gmail.com, tj@kernel.org,
        Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Subject: Need assistance fixing a tg3 driver side-effect on IPMI
Message-ID: <20121107082820.GP30936@casco.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I've been running into a problem while installing Debian Wheezy on a bunch
of 6-year old machines which have been running Squeeze happily for years.

They are SuperMicro-based (H8SSL opteron board), with two BCM95704A6 (Tigon3) 
interfaces, and a BMC/IPMI card (SuperMicro 1U) which shares eth0.

With a 2.6.32 kernel (and the 3.102 version of the tg3 driver) everything is fine.

With Debian's 3.2 (and tg3 3.121) I lose access to the IPMI LAN (or LANplus)
interface as soon as the tg3 module has been loaded. Even shutting down doesn't
give the interface back - I've got to pull the power plug.

Trying to git bisect the corresponding changes to the tg3 driver, I'm running
against a wall at the point where the source code has been moved to another
subtree back in 2011 (still a long time past Squeeze). I appear to be unable
to go back beyond that.

Can you advise how to find out when IPMI access got lost, and how to re-enable
it? Any suggestion is appreciated.
I suppose it wouldn't be as easy as "get the old source from 2.6.32, and plug
it into drivers/net/ethernet/broadcom, then rebuild the kernel" -?

Please keep me on CC, thanks.

Regards,
 Steffen
