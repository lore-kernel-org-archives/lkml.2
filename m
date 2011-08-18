Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1HRTIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:08:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47521 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1HRTIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:08:40 -0400
Date: Thu, 18 Aug 2011 20:08:39 +0100
To: richard@nod.at
Subject: Subject: [PATCH 58/91] um: take mconsole*.h to arch/um/drivers
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7xH-0007s8-PK@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/{include/shared => drivers}/mconsole.h     |    0
 .../um/{include/shared => drivers}/mconsole_kern.h |    0
 2 files changed, 0 insertions(+), 0 deletions(-)
 rename arch/um/{include/shared => drivers}/mconsole.h (100%)
 rename arch/um/{include/shared => drivers}/mconsole_kern.h (100%)

diff --git a/arch/um/include/shared/mconsole.h b/arch/um/drivers/mconsole.h
similarity index 100%
rename from arch/um/include/shared/mconsole.h
rename to arch/um/drivers/mconsole.h
diff --git a/arch/um/include/shared/mconsole_kern.h b/arch/um/drivers/mconsole_kern.h
similarity index 100%
rename from arch/um/include/shared/mconsole_kern.h
rename to arch/um/drivers/mconsole_kern.h
-- 
1.7.2.5


