Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1HRTLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:11:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48347 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab1HRTLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:11:00 -0400
Date: Thu, 18 Aug 2011 20:10:59 +0100
To: richard@nod.at
Subject: Subject: [PATCH 72/91] um: take ubd_user.h to its users...
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7zX-000806-TN@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/{include/shared => drivers}/ubd_user.h |    0
 1 files changed, 0 insertions(+), 0 deletions(-)
 rename arch/um/{include/shared => drivers}/ubd_user.h (100%)

diff --git a/arch/um/include/shared/ubd_user.h b/arch/um/drivers/ubd_user.h
similarity index 100%
rename from arch/um/include/shared/ubd_user.h
rename to arch/um/drivers/ubd_user.h
-- 
1.7.2.5


