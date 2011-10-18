Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab1JRX3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 19:29:24 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:14838
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751468Ab1JRX3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 19:29:22 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4E9E0B71.9020708@am.sony.com>
Date: Tue, 18 Oct 2011 16:27:45 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Russell King <rmk@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] ARM 4Kstacks: introduction
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm about to submit a set of patches (really pretty small)
to add 4K stack support to ARM (defaulted to 'N').

This has been kicking around in my Sony tree for a few years,
and it's about time to mainline it.  The first patch is
the actual 4KSTACKS patch.  See subsequent patches
for tools to help with stack reduction to avoid the problems
that apparently led to the removal of this feature on x86.

This set includes:
  0001-Add-support-for-4K-kernel-stacks-to-ARM.patch
  0002-Add-static-kernel-function-stack-size-analyzer-for-ARM.patch
  0003-Decrease-poll-and-select-stack-usage-when-using-4K-stacks.patch

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

