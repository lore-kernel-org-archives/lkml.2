Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab1I2OVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:21:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:51599 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756538Ab1I2OVa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:21:30 -0400
Subject: Re: [PATCH 1/4] fsl-rio: Split rio driver into two parts, RapidIO endpoint and RapidIO message unit
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1317263341-19010-1-git-send-email-Gang.Liu@freescale.com>
Date: Thu, 29 Sep 2011 09:21:34 -0500
Cc: <linuxppc-dev@lists.ozlabs.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <r58472@freescale.com>,
        <B11780@freescale.com>, <r61911@freescale.com>,
        Lian Minghuan-B31939 <Minghuan.Lian@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E143A9DC-91AC-4623-879B-AA3A80A916AC@kernel.crashing.org>
References: <1317263341-19010-1-git-send-email-Gang.Liu@freescale.com>
To: Liu Gang <Gang.Liu@freescale.com>
X-Mailer: Apple Mail (2.1244.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 28, 2011, at 9:28 PM, Liu Gang wrote:

> The Freescale PowerPC RapidIO controller consists of a RapidIO endpoint and a RapidIO
> message unit(RMU). Or use RapidIO message manager(RMan) to replace the RMU in DPAA
> architecture. Therefore, we should split the code into two function modules according
> to the hardware architecture.
> Add new struct for RMU module, and new initialization function to set up RMU module. This policy
> is very conducive to adding new module like RMan, or adding multi-ports or message units support.
> 
> Signed-off-by: Lian Minghuan-B31939 <Minghuan.Lian@freescale.com>
> Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
> ---
> arch/powerpc/sysdev/Makefile  |    2 +-
> arch/powerpc/sysdev/fsl_rio.c | 1152 +---------------------------------------
> arch/powerpc/sysdev/fsl_rio.h |   78 +++
> arch/powerpc/sysdev/fsl_rmu.c | 1163 +++++++++++++++++++++++++++++++++++++++++
> 4 files changed, 1267 insertions(+), 1128 deletions(-)
> create mode 100644 arch/powerpc/sysdev/fsl_rio.h
> create mode 100644 arch/powerpc/sysdev/fsl_rmu.c

Fix commit message so it doesn't go based 75 char column line wrap (same comment for other patches in the series)

- k