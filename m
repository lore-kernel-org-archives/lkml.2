Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1HBSON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 14:14:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:13854 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811Ab1HBSOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 14:14:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,307,1309762800"; 
   d="scan'208";a="3475225"
Date: Tue, 2 Aug 2011 11:14:03 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] The longterm Linux 2.6.35.14 kernel is released
Message-ID: <20110802181403.GA7087@tassilo.jf.intel.com>
References: <c20110801215908.GA11448@tassilo.jf.intel.com>
 <20110802062621.GA5893@sapphire.tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110802062621.GA5893@sapphire.tkos.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 09:26:21AM +0300, Baruch Siach wrote:
> Hi Andi,
> 
> > A note on the 2.6.35.13 git tags & branches: when releasing 2.6.35.13 I made
> > a mistake which resulted in the v2.6.35.13 tag being on a different
> > branch than the master tree.  I decided the continue on the branch,
> > not the tag, so you have to delete the v2.6.35.13 tag -- if you're
> > using that -- and refetch the new tag. If you just use the "master" branch
> > or the released patches/tarballs you don't need to do anything. Sorry about 
> > that.
> 
> The master branch of the longterm/linux-2.6.35.y.git tree does not seem to 
> include the v2.6.35.14 tag. How can I fetch v2.6.35.14 using git?

Hmm, it's on master at least. Maybe something is stale.

-Andi

[ak@hera linux-2.6.35.y.git]$ pwd
/pub/scm/linux/kernel/git/longterm/linux-2.6.35.y.git
[ak@hera linux-2.6.35.y.git]$ git log -1
commit 675f7660ffb0e1880011f6b3c4f9ac241491e3cd
Author: Andi Kleen <ak@linux.intel.com>
Date:   Mon Aug 1 13:56:51 2011 -0700

    release 2.6.35.14
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
[ak@hera linux-2.6.35.y.git]$ git show v2.6.35.14
tag v2.6.35.14
Tagger: Andi Kleen <ak@linux.intel.com>
Date:   Mon Aug 1 13:57:13 2011 -0700

2.6.35.14
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJONxMtAAoJELKWlWCweoOzWBEH/jtM0eVdiYtBc+IosGRt1cCo
J1Oc7Vtyo4dKtgCvH5ExgypHRKtCqBZPBCB/Nr3Yg0KXXEmYMuKadPC/FPn7wEf6
Yq1gqb60HFKA83b6Ebin/Y3dFi4cBwRIVMBxR8TJ++QEb5y+45cxiN+AHYoWry1g
iKxSuKPBFCYgWzfWPDkbfLYRx/Xpqz2OHKBpXgyr1SlsVZcVztCRAFc+fi8eYV4f
gElZGkxIsFVE09D5FKx5UST9cFWPS+dBLfYXgn998tciRs+cy/eq3R1wLElBP5LS
X5G9G9lg4/2D6fuPWY0Pu884X+jHTlGLeeFj6Fv9FKk0wibgOw/vjlcedtPfRFE=
=mAy2
-----END PGP SIGNATURE-----

commit 675f7660ffb0e1880011f6b3c4f9ac241491e3cd
Author: Andi Kleen <ak@linux.intel.com>
Date:   Mon Aug 1 13:56:51 2011 -0700

    release 2.6.35.14

-Andi
