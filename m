Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1HDOqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 10:46:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63977 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab1HDOqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 10:46:44 -0400
MIME-Version: 1.0
Date: Thu, 4 Aug 2011 22:46:41 +0800
Message-ID: <CAJd=RBBxoWxAG5+v=6XPBfx9eQ3e3mEisXS+gWEvRE9x56tPsA@mail.gmail.com>
Subject: [RFC patch] MIPS: deduplicate comment for i8259
From: Hillf Danton <dhillf@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment for the slave PIC is changed from 8259A-1 to 8259A-2.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 arch/mips/kernel/i8259.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/i8259.c b/arch/mips/kernel/i8259.c
index c018696..55d2624 100644
--- a/arch/mips/kernel/i8259.c
+++ b/arch/mips/kernel/i8259.c
@@ -230,7 +230,7 @@ static int i8259A_shutdown(struct sys_device *dev)
 	 */
 	if (i8259A_auto_eoi >= 0) {
 		outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
-		outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-1 */
+		outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
 	}
 	return 0;
 }
