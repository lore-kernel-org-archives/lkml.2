Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab2ERS7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:59:11 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53222 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758451Ab2ERS67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:58:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCHv3 0/4] coupled cpuidle state support
Date: Fri, 18 May 2012 21:03:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Kevin Hilman <khilman@ti.com>,
        Len Brown <len.brown@intel.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
References: <1336438662-10484-1-git-send-email-ccross@android.com> <4FB62611.7080908@ti.com>
In-Reply-To: <4FB62611.7080908@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205182103.56301.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 18, 2012, Santosh Shilimkar wrote:
> On Tuesday 08 May 2012 06:27 AM, Colin Cross wrote:
> > On some ARM SMP SoCs (OMAP4460, Tegra 2, and probably more), the
> > cpus cannot be independently powered down, either due to
> > sequencing restrictions (on Tegra 2, cpu 0 must be the last to
> > power down), or due to HW bugs (on OMAP4460, a cpu powering up
> > will corrupt the gic state unless the other cpu runs a work
> > around).  Each cpu has a power state that it can enter without
> > coordinating with the other cpu (usually Wait For Interrupt, or
> > WFI), and one or more "coupled" power states that affect blocks
> > shared between the cpus (L2 cache, interrupt controller, and
> > sometimes the whole SoC).  Entering a coupled power state must
> > be tightly controlled on both cpus.
> > 
> 
> [...]
> 
> > This series has been tested and reviewed by Santosh and Kevin
> > for OMAP4, which has a cpuidle series ready for 3.5, and Tegra
> > and Exynos5 patches are in progress.  I think this is ready to
> > go in.  Lean, are you maintaining a cpuidle tree for linux-next?
> > If not, I can publish a tree for linux-next, or this could go in
> > through Arnd's tree.
> 
> I haven't seen any response so far on who is lining up this
> series for 3.5 ? Not sure if it made it to linux-next either.

That should be Len, but he's been silent recently.

How urgent is it?

Rafael
