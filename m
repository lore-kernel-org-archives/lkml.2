Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab0K3I3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 03:29:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52115 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab0K3I3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 03:29:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4CF4B597.4030708@jp.fujitsu.com>
Date: Tue, 30 Nov 2010 17:28:07 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        suresh.b.siddha@intel.com
CC: x86@kernel.org, linux-kernel@vger.kernel.org, indou.takao@jp.fujitsu.com
Subject: [PATCH 0/2] Fix dmar fault interrupt problems
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are patches to fix the following problems regarding dmar fault interrupt.

- No dmar fault event is notified in x2apic cluster mode
- Changing IRQ affinity of dmar fault interrupt causes "No irq handler
  for vector (irq XX)" message and dmar fault interrupts are never
  notified after that.

Regards,
Kenji Kaneshige

