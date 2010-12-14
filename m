Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab0LNOb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 09:31:58 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51582 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab0LNOb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:31:57 -0500
MIME-Version: 1.0
X-Originating-IP: [109.186.34.126]
In-Reply-To: <1291420247-18171-1-git-send-email-ohad@wizery.com>
References: <1291420247-18171-1-git-send-email-ohad@wizery.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 14 Dec 2010 16:31:36 +0200
Message-ID: <AANLkTin1fd=Kei7Fo6G+uR+270HdTkc71fvsA6qjBjcA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Introduce hardware spinlock framework
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Tony,

On Sat, Dec 4, 2010 at 1:50 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> OMAP4 introduces a Hardware Spinlock device, which provides hardware
> assistance for synchronization and mutual exclusion between heterogeneous
> processors and those not operating under a single, shared operating system
> (e.g. OMAP4 has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP).
>
> The intention of this hardware device is to allow remote processors,
> that have no alternative mechanism to accomplish synchronization and mutual
> exclusion operations, to share resources (such as memory and/or any other
> hardware resource).
>
> This patchset adds hwspinlock framework that makes it possible
> for drivers to use those hwspinlock devices and stay platform-independent.

...

>  Documentation/hwspinlock.txt               |  299 +++++++++++++++
>  arch/arm/mach-omap2/Makefile               |    1 +
>  arch/arm/mach-omap2/hwspinlock.c           |   63 ++++
>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   64 ++++
>  drivers/Kconfig                            |    2 +
>  drivers/Makefile                           |    1 +
>  drivers/hwspinlock/Kconfig                 |   22 ++
>  drivers/hwspinlock/Makefile                |    6 +
>  drivers/hwspinlock/hwspinlock.h            |   61 +++
>  drivers/hwspinlock/hwspinlock_core.c       |  557 ++++++++++++++++++++++++++++
>  drivers/hwspinlock/omap_hwspinlock.c       |  231 ++++++++++++
>  include/linux/hwspinlock.h                 |  298 +++++++++++++++
>  12 files changed, 1605 insertions(+), 0 deletions(-)

Can you please have a look and say if this looks OK ?

If it does, where would you prefer this to go through ?

Thanks,
Ohad.
