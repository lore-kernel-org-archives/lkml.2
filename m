Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1HRTJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:09:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47551 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab1HRTJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:09:40 -0400
Date: Thu, 18 Aug 2011 20:09:39 +0100
To: richard@nod.at
Subject: Subject: [PATCH 64/91] um: move asm/desc.h into arch/x86/um/asm
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7yF-0007w6-Qp@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


its only purpose is to shadow the x86 asm/desc.h

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/{um/include => x86/um}/asm/desc.h |    0
 1 files changed, 0 insertions(+), 0 deletions(-)
 rename arch/{um/include => x86/um}/asm/desc.h (100%)

diff --git a/arch/um/include/asm/desc.h b/arch/x86/um/asm/desc.h
similarity index 100%
rename from arch/um/include/asm/desc.h
rename to arch/x86/um/asm/desc.h
-- 
1.7.2.5


