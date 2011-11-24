Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab1KXOZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 09:25:07 -0500
Received: from gate.crashing.org ([63.228.1.57]:36116 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab1KXOZF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 09:25:05 -0500
Subject: Re: [PATCH v2] Integrated Flash Controller support
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <CCF7C6DB-437C-4140-894F-2F497AD610DC@kernel.crashing.org>
Date: Thu, 24 Nov 2011 08:24:33 -0600
Cc: Li Yang-R58472 <r58472@freescale.com>, Artem.Bityutskiy@nokia.com,
        "b35362@freescale.com>" <b35362@freescale.com>,
        "linux-kernel@vger.kernel.org Kernel" <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, Scott Wood <scottwood@freescale.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <8EDB3DC6-63E5-4D5C-BB52-15F32B85C5DD@kernel.crashing.org>
References: <1320053901-23801-1-git-send-email-b35362@freescale.com> <CCF7C6DB-437C-4140-894F-2F497AD610DC@kernel.crashing.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 22, 2011, at 9:41 PM, Kumar Gala wrote:

> 
> On Oct 31, 2011, at 4:38 AM, <b35362@freescale.com> <b35362@freescale.com> wrote:
> 
>> From: Liu Shuo <b35362@freescale.com>
>> 
>> Integrated Flash Controller supports various flashes like NOR, NAND
>> and other devices using NOR, NAND and GPCM Machine available on it.
>> IFC supports four chip selects.
>> 
>> Signed-off-by: Dipen Dudhat <Dipen.Dudhat@freescale.com>
>> Signed-off-by: Scott Wood <scottwood@freescale.com>
>> Signed-off-by: Li Yang <leoli@freescale.com>
>> Signed-off-by: Liu Shuo <b35362@freescale.com>
>> ---
>> arch/powerpc/Kconfig               |    4 +
>> arch/powerpc/include/asm/fsl_ifc.h |  834 ++++++++++++++++++++++++++++++++++++
>> arch/powerpc/sysdev/Makefile       |    1 +
>> arch/powerpc/sysdev/fsl_ifc.c      |  322 ++++++++++++++
>> 4 files changed, 1161 insertions(+), 0 deletions(-)
>> create mode 100644 arch/powerpc/include/asm/fsl_ifc.h
>> create mode 100644 arch/powerpc/sysdev/fsl_ifc.c
> 
> Guys,
> 
> How are we handling this patchset since it touches drivers/mtd/nand?

Artem,

thoughts?

- k