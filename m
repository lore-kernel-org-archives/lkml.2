Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab1LNMdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 07:33:09 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62798 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756967Ab1LNMdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 07:33:05 -0500
Date: Wed, 14 Dec 2011 12:32:44 +0000
From: Will Deacon <will.deacon@arm.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [linux-next] make  s5p64x0_defconfig build error
Message-ID: <20111214123244.GE7122@mudshark.cambridge.arm.com>
References: <1323838630.18517.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323838630.18517.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 04:57:10AM +0000, Axel Lin wrote:
> I got below build error on linux-next 20111213.
> 
>   CC      arch/arm/kernel/process.o
> In file included from arch/arm/mach-s5p64x0/include/mach/system.h:16,
>                  from arch/arm/kernel/process.c:64:
> arch/arm/plat-samsung/include/plat/system-reset.h:19:2: error: #error Fix me up
> make[1]: *** [arch/arm/kernel/process.o] Error 1
> make: *** [arch/arm/kernel] Error 2

The clue is in the commit message:

commit d0f7e2beabe6a116152ccc31959b6654b6ef0071
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Tue Dec 6 12:57:02 2011 +0000

    ARM: restart: Temporary #error to persuade platform maintainers to take the restart changes seriously

    Force builds to fail to ensure that platform maintainers take the
    restart changes seriously, and sort out fixing their code before the
    next merge window.

    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>


Will
