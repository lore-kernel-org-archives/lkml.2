Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab1GTNCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:02:40 -0400
Received: from mail.tanisys.com ([207.114.241.63]:10846 "EHLO
	tanisys-ex2.Tanisys.Local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751418Ab1GTNCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:02:38 -0400
From: Ayman Elkhashab <aymane@elkhashab.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Tony Breeds <tony@bakeyournoodle.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: Ayman El-Khashab <ayman@elkhashab.com>
Subject: [v3 PATCH 0/1] powerpc/4xx: enable and fix pcie gen1/gen2 on the 460sx
Date: Wed, 20 Jul 2011 08:02:28 -0500
Message-Id: <1311166949-2543-1-git-send-email-aymane@elkhashab.com>
X-Mailer: git-send-email 1.7.4.3
In-Reply-To: <1310603611-8960-2-git-send-email-ayman@elkhashab.com>
References: <1310603611-8960-2-git-send-email-ayman@elkhashab.com>
X-OriginalArrivalTime: 20 Jul 2011 13:02:37.0935 (UTC) FILETIME=[4CEEFFF0:01CC46DD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ayman El-Khashab <ayman@elkhashab.com>

Changes from v1->v2
Added definitions for the bits in the OMRxMSKL registers
Refactored the setting of the OMRxMSKL registers for the 460SX
Added bit defines for the PECFG_460SX_DLLSTA register

Changes from v2->v3
Fixed commit message to be more clear as to what was done

Ayman El-Khashab (1):
  powerpc/4xx: enable and fix pcie gen1/gen2 on the 460sx

 arch/powerpc/sysdev/ppc4xx_pci.c |   89 ++++++++++++++++++++++++++++++-------
 arch/powerpc/sysdev/ppc4xx_pci.h |   12 +++++
 2 files changed, 84 insertions(+), 17 deletions(-)

-- 
1.7.4.3

