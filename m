Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab0HPPvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 11:51:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:58294 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406Ab0HPPvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 11:51:22 -0400
Date: Mon, 16 Aug 2010 17:51:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: explain 'no-kvmclock' kernel parameter
Message-ID: <alpine.LNX.2.00.1008161751070.1019@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no-kvmclock kernel parameter is missing its explanation in
Documentation/kernel-parameters.txt. Add it.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 Documentation/kernel-parameters.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2c85c06..0f9e299 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1693,6 +1693,8 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	nojitter	[IA64] Disables jitter checking for ITC timers.
 
+	no-kvmclock	[X86,KVM] Disable paravirtualized KVM clock driver
+
 	nolapic		[X86-32,APIC] Do not enable or use the local APIC.
 
 	nolapic_timer	[X86-32,APIC] Do not use the local APIC timer.

