Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1HRTGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:06:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47460 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab1HRTGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:06:10 -0400
Date: Thu, 18 Aug 2011 20:06:09 +0100
To: richard@nod.at
Subject: Subject: [PATCH 43/91] um: arch_hweight.h is needed only on
 uml-x86
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7ur-0007kc-Jy@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/{include => sys-x86}/asm/arch_hweight.h |    0
 1 files changed, 0 insertions(+), 0 deletions(-)
 rename arch/um/{include => sys-x86}/asm/arch_hweight.h (100%)

diff --git a/arch/um/include/asm/arch_hweight.h b/arch/um/sys-x86/asm/arch_hweight.h
similarity index 100%
rename from arch/um/include/asm/arch_hweight.h
rename to arch/um/sys-x86/asm/arch_hweight.h
-- 
1.7.2.5


