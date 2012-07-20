Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2GTMlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 08:41:09 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:54459
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758Ab2GTMlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 08:41:07 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh2a8h668h839hd24he5bhf0ah107ah)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>,
        <galak@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: [PATCH v8 0/7] power management patch set
Date: Fri, 20 Jul 2012 20:42:32 +0800
Message-ID: <1342788159-27529-1-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.6.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes for v8:
* Separated the cpu hotplug patch into three patches, as follows
  [PATCH v8 1/7] powerpc/smp: use a struct epapr_spin_table to replace macros
  [PATCH v8 2/7] powerpc/smp: add generic_set_cpu_up() to set cpu_state as CPU_UP_PREPARE
  [PATCH v8 4/7] powerpc/85xx: add HOTPLUG_CPU support

* Replaced magic numbers with macros in "[PATCH 5/7] powerpc/85xx: add sleep and deep sleep support"

* no change to the rest of the patch set

