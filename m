Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab2IKOKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:10:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61331 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab2IKOKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:10:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 04/16] ARM: imx: move platform_data definitions
Date: Tue, 11 Sep 2012 14:10:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Chris Ball <cjb@laptop.org>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alan Cox <alan@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Shawn Guo <shawn.guo@linaro.org>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de> <1347368390-31252-4-git-send-email-arnd@arndb.de> <Pine.LNX.4.64.1209111538000.22084@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1209111538000.22084@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209111410.05698.arnd@arndb.de>
X-Provags-ID: V02:K0:d9+MfU37KoYplqBgoSLQgNlJ5oSEnCikeELanfZdpad
 SpICJnpvRcxKZAfIfoLg+IdFKoPmhfH9TxNVwhdea3hWU0Znz6
 sx3mePHUBIhYThveHdA4nKW0ryrnYVIid4OtS0qYUei0gu6CKN
 nT9fVCzniWBKdIUQBN99BhO9DNQucKrMdAktf+m6+xrRUDWkhH
 XujOsK3TVKOkpCQO2p2ObA2t+yJiq5Vx4rYN4wA1e0YXvOA0Bt
 0SnnQPirQ5gWygwKQXR3NlW8cCJIWO1VGhwL7kExlHbK7OTmW4
 2kTAATbsWyTIq0M9JM8YwMel2B0pNxL1yBHU7JB+mRvWbVx5xp
 +W/w/tvS1V13uEEqMAbw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 September 2012, Guennadi Liakhovetski wrote:
> Hi Arnd
> 
> It probably wouldn't be very difficult to also include 
> arch/arm/plat-mxc/include/mach/ipu.h in this your patch, but you can also 
> leave it for later. Just to make sure it's not something that would make 
> your future patching more complicated.
> 

For now, I've done only the straight renames but left the ones that looked
like they need more complex changes of any sort. Looking at ipu.h, it seems
that this header file defines data that is used inside of the driver but not
in the platform device definition, so we'd need to split it up and move
the part that is only used inside of the driver into a different place.

Of course, I could alo be mistaken and not have realized that actually all
of this file is platform data.

	Arnd
