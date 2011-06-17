Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab1FQIiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:38:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47830 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab1FQIh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:37:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DFB1242.90404@jp.fujitsu.com>
Date: Fri, 17 Jun 2011 17:37:22 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>
Subject: [PATCH 0/8] x86, mce: misc fix/cleanups, cont
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set contains small patches, newly invented through the
recent discussion about error recovery etc.
Not drastic, but small improvements.

(This set is based on today's tip/ras/core branch.)

Thanks,
H.Seto

 arch/x86/include/asm/mce.h             |    2 -
 arch/x86/kernel/cpu/mcheck/mce.c       |  340 ++++++++++++++++----------------
 arch/x86/kernel/cpu/mcheck/mce_intel.c |    2 +-
 3 files changed, 173 insertions(+), 171 deletions(-)

Hidetoshi Seto (8):
      x86, mce: stop calling del_timer_sync() from interrupt
      x86, mce: remove redundant mce_available() checks
      x86, mce: introduce mce_timer_add()
      x86, mce: rename bootparam parser
      x86, mce: introduce mce_sysdev_init()
      x86, mce: introduce mce_memory_failure_process()
      x86, mce: rework use of TIF_MCE_NOTIFY
      x86, mce, edac: call edac_mce_parse() once per a record

