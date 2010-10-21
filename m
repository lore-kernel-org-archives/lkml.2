Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab0JUOus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:50:48 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:7371 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab0JUOuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:50:46 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i2a8h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3extmailp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LANAK3-02-7E9-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
        <brgerst@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <robert.richter@amd.com>,
        <andreas.herrmann3@amd.com>, Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 0/1] Cleanup xsave/xrstor support.
Date: Thu, 21 Oct 2010 16:50:26 +0200
Message-ID: <1287672627-275685-1-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b. Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr. 43632
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm resending this patch for inclusion into tip. This was originally
part of my work to support LWP, but since it is just a cleanup of the
xsave code it is completely independent of LWP.

Hans Rosenfeld (1):
  Cleanup xsave/xrstor support.

 arch/x86/include/asm/i387.h  |   20 +++-------
 arch/x86/include/asm/xsave.h |   81 +++++++++++++++---------------------------
 arch/x86/kernel/traps.c      |    2 +-
 arch/x86/kernel/xsave.c      |    4 +-
 4 files changed, 38 insertions(+), 69 deletions(-)


