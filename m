Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab1ESNyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:54:41 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:51223
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933215Ab1ESNyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:54:39 -0400
X-SpamScore: -1
X-BigFish: VS-1(z3c23mz11f6Nzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Timur Tabi <timur@freescale.com>
To: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: [PATCH 0/7] This patchset adds support for running Linux under the Freescale hypervisor,
Date: Thu, 19 May 2011 08:54:25 -0500
Message-ID: <1305813272-31826-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

have hypervisor extensions (e.g. the P4080 which has an e500mc core).

I think it makes sense for this patchset to go through Kumar Gala's -next 
branch, but I still need ACKs from various people on the parts that are
not e500-specific.

1. powerpc: make irq_choose_cpu() available to all PIC drivers
2. powerpc: introduce ePAPR embedded hypervisor hcall interface
3. powerpc: introduce the ePAPR embedded hypervisor vmpic driver
4. powerpc: add Freescale hypervisor partition control functions
5. powerpc/85xx: add board support for the Freescale hypervisor
6. tty/powerpc: introduce the ePAPR embedded hypervisor byte channel driver
7. drivers/misc: introduce Freescale hypervisor management driver

Ben Herrenschmidt, please review/ack parts 1-3.

Greg Kroah-Hartman, please review/ack part 6.

Andrew Morton, please review/ack part 7.

Thank you very much for looking at this patchset.  I hope to have it included 
in 2.6.40.

