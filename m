Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0ELKYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 06:24:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:40887 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab0ELKYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 06:24:19 -0400
Subject: Re: [git pull] Please pull powerpc.git merge branch
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1273650396.21352.121.camel@pasglop>
Date: Wed, 12 May 2010 05:24:04 -0500
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <B0104965-09F9-4372-AA9F-F6D0FDEA67F2@kernel.crashing.org>
References: <1273650396.21352.121.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 12, 2010, at 2:46 AM, Benjamin Herrenschmidt wrote:

> Hi Linus !
> 
> Please pull this perf event fix from Paulus. Without it, using perf event
> can potentially oops the machine at any time.
> 
> Thanks !
> 
> Cheers,
> Ben.
> 
> The following changes since commit cea0d767c29669bf89f86e4aee46ef462d2ebae8:
>  Linus Torvalds (1):
>        Merge branch 'hwmon-for-linus' of git://git.kernel.org/.../jdelvare/staging
> 
> are available in the git repository at:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge
> 
> Paul Mackerras (1):
>      powerpc/perf_event: Fix oops due to perf_event_do_pending call
> 
> arch/powerpc/include/asm/hw_irq.h |   38 -----------------------
> arch/powerpc/kernel/asm-offsets.c |    1 -
> arch/powerpc/kernel/entry_64.S    |    9 -----
> arch/powerpc/kernel/irq.c         |    6 ----
> arch/powerpc/kernel/time.c        |   60 +++++++++++++++++++++++++++++-------
> 5 files changed, 48 insertions(+), 66 deletions(-)
> 

Ben,

Did where you going to also send linus:

http://patchwork.ozlabs.org/patch/51496/

- k