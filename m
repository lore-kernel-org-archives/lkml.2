Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab0GURXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:23:06 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:37507
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517Ab0GURWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:22:01 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i87h2a8h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L5X434-01-7F2-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] x86, xsave: some code cleanups and reworks, -v2
Date: Wed, 21 Jul 2010 19:03:51 +0200
Message-ID: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans Peter, Suresh, and Cyrill, thanks for your feedback.

This is version 2 of the patch series.

Patches 2, 4, 7 are unchanged compared to -v1.

Patch 1 folds the initialization code into one patch. fpu_init() is
now called before xsave_init(). xsave_init() can later overwrite
xstate_size based on xstate features.

Patch 3 replaces all hardcoded XSTATE_CPUID values know. cpuid_level
is now taken from boot_cpu_data.

Patches 5 and 6 are new:
* add __init attribute to setup_xstate_features()
* disable xsave in i387 emulation mode

-Robert


