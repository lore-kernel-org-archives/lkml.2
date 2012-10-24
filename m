Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab2JXMKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:10:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53882 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab2JXMKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:10:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [PATCH v3 0/5] zynq subarch cleanups
Date: Wed, 24 Oct 2012 12:09:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, John Linn <john.linn@xilinx.com>,
        Nick Bowler <nbowler@elliptictech.com>
References: <20121024003218.GA31625@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121024003218.GA31625@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210241209.58655.arnd@arndb.de>
X-Provags-ID: V02:K0:ajlkjRIPUuQgxFSIDt5xqbXjbluZiVtM0rLv4r/Y4y9
 rISSd0yyfyMuqtB9FoCSScaluk7Dkvpsa3i+6KMfDQ2ATHCqw9
 nKH5Hk5vO78ey6ONezPfGoU5lUVwrTnVFroJE9hGz2dhiwvj4N
 4ODy694LKHDZetCdEGiFnlcPaCYZ3bBdb/9Z9ylsAvrNfKk0j2
 S/wEdskt4OZu4GXRN8i/kqSIe/6AkesgyEwc/dQRYnKlqWSx4W
 tHlMJ6eoWgygQS0rQ3OVSkUCvCuTC6T+6Vi/X732MAeP0A6Ksx
 MRIOlL3f8oJcOyxkWhNLpigTCOSFykovqKa51xg4jVHm5yLvoG
 D4hdZ8l8m0OseMeWTCsE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2012, Josh Cartwright wrote:
> Things have been relatively quiet on the Zynq front lately.  This patchset does
> a bit of cleanup of the Zynq subarchitecture.  It was the necessary set of
> things I had to do to get a zynq target booting with the upstream qemu model.
> 
> Patches 1 and 2 move zynq to use the GIC and pl310 L2 cache controller device
> tree mappings respectively.
> 
> Patch 3 removes unused clock infrastructure.  the plan is to rework the
> out-of-tree Xilinx generic clk support into something suitable for merging.
> What's in tree now just isn't used at all, and can be removed.
> 
> Patch 4 and 5 move around the static peripheral mappings into the vmalloc area.

Looks all good to me now.

> 
> I intentionally did not Cc stable on patch 5, even though you had
> suggested otherwise.  I do not think it will apply cleanly to the stable
> trees independent of the other patches.  Additionally, with the current
> state of zynq upstream, I'm not convinced there would be enough users to
> make it worth the effort.

Ok, fair enough.

> Additionally, I've left the SCU static mapping around, even though its
> currently unused.  We'll eventually need it around (maybe in a different form)
> when SMP support is added.

Right.

John, are you going to pick up these patches and send a pull request?

	Arnd
