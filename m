Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab0GANXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:23:54 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:53726 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753666Ab0GANXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:23:52 -0400
Date: Thu, 1 Jul 2010 15:23:51 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 06/33] Removing dead SHARPSL_LOCOMO
Message-ID: <20100701132351.GB32541@faui48a.informatik.uni-erlangen.de>
References: <cover.1277911345.git.siccegge@cs.fau.de> <b43850b1a1909496718e39687d1ca00543aa30ec.1277911346.git.siccegge@cs.fau.de> <AANLkTimVRdxeeQKazgFSIQJYtbmHnjDN5lUnTrVv6uoI@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimVRdxeeQKazgFSIQJYtbmHnjDN5lUnTrVv6uoI@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 10:34:13AM +0800, Eric Miao wrote:
> On Wed, Jun 30, 2010 at 11:55 PM, Christoph Egger <siccegge@cs.fau.de> wrote:
> > SHARPSL_LOCOMO doesn't exist in Kconfig, therefore removing all
> > references for it from the source code.
> >
> 
> A good catch, though SHARPSL_LOCOMO has be changed to SHARP_LOCOMO
> later, so a better fix would be the name change only.

Hi! Updated patch below

----
From: Christoph Egger <siccegge@cs.fau.de>
Date: Wed, 30 Jun 2010 12:36:20 +0200
Subject: [PATCH 06/33] Replacing dead SHARPSL_LOCOMO with SHARP_LOCOMO

SHARP_LOCOMO doesn't exist in Kconfig, therefore replacing all
references for it with SHARP_LOCOMO in the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-sa1100/include/mach/irqs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-sa1100/include/mach/irqs.h b/arch/arm/mach-sa1100/include/mach/irqs.h
index 8c8845b..d18f21a 100644
--- a/arch/arm/mach-sa1100/include/mach/irqs.h
+++ b/arch/arm/mach-sa1100/include/mach/irqs.h
@@ -77,7 +77,7 @@
  */
 #ifdef CONFIG_SA1111
 #define NR_IRQS			(IRQ_BOARD_END + 55)
-#elif defined(CONFIG_SHARPSL_LOCOMO)
+#elif defined(CONFIG_SHARP_LOCOMO)
 #define NR_IRQS			(IRQ_BOARD_START + 4)
 #else
 #define NR_IRQS			(IRQ_BOARD_START)
-- 
1.7.0.4


