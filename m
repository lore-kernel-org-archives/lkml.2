Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab2BUGZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 01:25:21 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52744 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2BUGZU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 01:25:20 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Nori, Sekhar" <nsekhar@ti.com>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: RE: [PATCH v4 0/3] Moving EMIF driver to MFD framework
Thread-Topic: [PATCH v4 0/3] Moving EMIF driver to MFD framework
Thread-Index: AQHM5wEqPI+EwgoE5EuvBBBJl20G6ZZG9I+g
Date: Tue, 21 Feb 2012 06:24:56 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC31769AF1@DBDE01.ent.ti.com>
References: <1328771908-32527-1-git-send-email-prakash.pm@ti.com>
In-Reply-To: <1328771908-32527-1-git-send-email-prakash.pm@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I do not see any comments on this series. Can it be applied?

Thanks,
Prakash

On Thu, Feb 09, 2012 at 12:48:25, Manjunathappa, Prakash wrote:
> Patch series are based on the discussion and concerns expressed in
> davinci-linux-open-source community. Here is the link for the same:
> http://davinci-linux-open-source.1494791.n2.nabble.com/PATCH-arm-davinci-configure-davinci-aemif-chipselects-through-OF-tt7059739.html#none
> 
> Manjunathappa, Prakash (3):
>   arm:davinci: prepare to move aemif driver to drivers/mfd
>   arm:davinci: move emif driver to drivers/mfd from mach-davinci folder
>   arm:davinci: move NAND and NOR devices as aemif MFD slaves
> 
>  arch/arm/Kconfig                                   |    1 +
>  arch/arm/mach-davinci/Makefile                     |    2 +-
>  arch/arm/mach-davinci/aemif.c                      |  133 -------------
>  arch/arm/mach-davinci/board-da830-evm.c            |   33 +++-
>  arch/arm/mach-davinci/board-da850-evm.c            |   56 +++---
>  arch/arm/mach-davinci/board-dm355-evm.c            |   33 +++-
>  arch/arm/mach-davinci/board-dm355-leopard.c        |   35 +++-
>  arch/arm/mach-davinci/board-dm365-evm.c            |   34 +++-
>  arch/arm/mach-davinci/board-dm644x-evm.c           |  175 ++++++++++-------
>  arch/arm/mach-davinci/board-dm646x-evm.c           |   32 +++-
>  arch/arm/mach-davinci/board-mityomapl138.c         |   34 +++-
>  arch/arm/mach-davinci/board-neuros-osd2.c          |    1 +
>  arch/arm/mach-davinci/board-sffsdr.c               |   34 +++-
>  drivers/mfd/Makefile                               |    1 +
>  drivers/mfd/davinci_aemif.c                        |  206 ++++++++++++++++++++
>  drivers/mtd/nand/davinci_nand.c                    |    2 +-
>  .../aemif.h => include/linux/mfd/davinci_aemif.h   |   14 ++
>  17 files changed, 527 insertions(+), 299 deletions(-)
>  delete mode 100644 arch/arm/mach-davinci/aemif.c
>  create mode 100644 drivers/mfd/davinci_aemif.c
>  rename arch/arm/mach-davinci/include/mach/aemif.h => include/linux/mfd/davinci_aemif.h (74%)
> 
> 

