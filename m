Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1HRTLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:11:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48358 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab1HRTLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:11:30 -0400
Date: Thu, 18 Aug 2011 20:11:29 +0100
To: richard@nod.at
Subject: Subject: [PATCH 75/91] um: irq_vectors.h just shadows x86 one
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu801-00080s-U2@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/{um/include => x86/um}/asm/irq_vectors.h |    0
 1 files changed, 0 insertions(+), 0 deletions(-)
 rename arch/{um/include => x86/um}/asm/irq_vectors.h (100%)

diff --git a/arch/um/include/asm/irq_vectors.h b/arch/x86/um/asm/irq_vectors.h
similarity index 100%
rename from arch/um/include/asm/irq_vectors.h
rename to arch/x86/um/asm/irq_vectors.h
-- 
1.7.2.5


