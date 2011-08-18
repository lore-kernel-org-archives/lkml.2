Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab1HRTLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:11:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48352 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab1HRTLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:11:10 -0400
Date: Thu, 18 Aug 2011 20:11:09 +0100
To: richard@nod.at
Subject: Subject: [PATCH 73/91] um: asm/apic.h is there only to shadow the x86 one...
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7zh-00080N-Tb@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... so take it to arch/um/x86/asm.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/{um/include => x86/um}/asm/apic.h |    0
 1 files changed, 0 insertions(+), 0 deletions(-)
 rename arch/{um/include => x86/um}/asm/apic.h (100%)

diff --git a/arch/um/include/asm/apic.h b/arch/x86/um/asm/apic.h
similarity index 100%
rename from arch/um/include/asm/apic.h
rename to arch/x86/um/asm/apic.h
-- 
1.7.2.5


