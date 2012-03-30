Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493Ab2C3AL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 20:11:57 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:56982 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933371Ab2C3ALv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 20:11:51 -0400
X-SpamScore: -6
X-BigFish: VPS-6(z21eNzzz1202hzzz2fh668h839hd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F74FA2F.9080406@am.sony.com>
Date: Thu, 29 Mar 2012 17:11:27 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: <linux-rt-users@vger.kernel.org>, <tglx@linutronix.de>
Subject: 3.2.12-rt22 on ARM
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.12-rt22 builds and boots on some ARM boards (PandaBoard, Realview) for:

  - SMP, PREEMPT_RT_FULL
  - SMP, PREEMPT_NONE
  - UP, PREEMPT_RT_FULL
  - UP, PREEMPT_NONE

I'm still fighting with my out of mainline ARM board to move it
to 3.2 and boot SMP.

-Frank

