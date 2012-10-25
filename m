Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424Ab2JYPrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:47:00 -0400
Received: from mail.southpole.se ([193.12.106.18]:51625 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914Ab2JYPq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:46:56 -0400
From: Jonas Bonn <jonas@southpole.se>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 0/2] openrisc: more kernel_thread cleanup
Date: Thu, 25 Oct 2012 17:46:37 +0200
Message-Id: <1351179999-8376-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.9.5
X-Assp-Version: 2.2.1(12265) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 80014-11288
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

A couple of patches here that continue the cleanup outlined in the
kernel_thread discussion.  Feel free to take these via your tree if
you feel that's appropriate; otherwise let me know and I'll throw
these into the openrisc tree.

/Jonas

Jonas Bonn (2):
  openrisc: move sys_clone's stack determination to copy_thread
  openrisc: determine regs directly in copy_thread

 arch/openrisc/kernel/entry.S    |    6 ++----
 arch/openrisc/kernel/process.c  |    9 +++++++--
 arch/openrisc/kernel/sys_or32.c |   15 ++++-----------
 3 files changed, 13 insertions(+), 17 deletions(-)

-- 
1.7.9.5

