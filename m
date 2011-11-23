Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806Ab1KWDl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 22:41:29 -0500
Received: from gate.crashing.org ([63.228.1.57]:38334 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113Ab1KWDl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 22:41:28 -0500
Subject: Re: [PATCH v2] Integrated Flash Controller support
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1320053901-23801-1-git-send-email-b35362@freescale.com>
Date: Tue, 22 Nov 2011 21:41:00 -0600
Cc: linux-mtd@lists.infradead.org,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "b35362@freescale.com>" <b35362@freescale.com>,
        "linux-kernel@vger.kernel.org Kernel" <linux-kernel@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>,
        Scott Wood <scottwood@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <CCF7C6DB-437C-4140-894F-2F497AD610DC@kernel.crashing.org>
References: <1320053901-23801-1-git-send-email-b35362@freescale.com>
To: Artem.Bityutskiy@nokia.com, David Woodhouse <dwmw2@infradead.org>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 31, 2011, at 4:38 AM, <b35362@freescale.com> <b35362@freescale.com> wrote:

> From: Liu Shuo <b35362@freescale.com>
> 
> Integrated Flash Controller supports various flashes like NOR, NAND
> and other devices using NOR, NAND and GPCM Machine available on it.
> IFC supports four chip selects.
> 
> Signed-off-by: Dipen Dudhat <Dipen.Dudhat@freescale.com>
> Signed-off-by: Scott Wood <scottwood@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> Signed-off-by: Liu Shuo <b35362@freescale.com>
> ---
> arch/powerpc/Kconfig               |    4 +
> arch/powerpc/include/asm/fsl_ifc.h |  834 ++++++++++++++++++++++++++++++++++++
> arch/powerpc/sysdev/Makefile       |    1 +
> arch/powerpc/sysdev/fsl_ifc.c      |  322 ++++++++++++++
> 4 files changed, 1161 insertions(+), 0 deletions(-)
> create mode 100644 arch/powerpc/include/asm/fsl_ifc.h
> create mode 100644 arch/powerpc/sysdev/fsl_ifc.c

Guys,

How are we handling this patchset since it touches drivers/mtd/nand?

- k