Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab0IBVX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:23:58 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51682 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211Ab0IBVHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:07:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=f/KDoxJi6mGzPDcT6fAns7nJQ6rCHoZ29WwwQSPhVs061k8BdCMdIiJ6ovHd/zw23P
         CwpscRnQzUFWP4FKr2lw9Y3fHSO19q6hhaHZsgfqbVFXPwDAYMEQjTviYXYjtte8VJgL
         e51ARN8EAHpypKHSfJfwMPzw9cwLyCwMlrG7E=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 17/91] arch/arm/mach-pxa/idp.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:07:46 -0700
Message-Id: <1283461679-7851-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461679-7851-1-git-send-email-justinmattock@gmail.com>
References: <1283461679-7851-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/arm/mach-pxa/idp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/idp.c b/arch/arm/mach-pxa/idp.c
index bc78c4d..25864d8 100644
--- a/arch/arm/mach-pxa/idp.c
+++ b/arch/arm/mach-pxa/idp.c
@@ -11,8 +11,8 @@
  *              Initial code
  *
  *  2005-02-15: Cliff Brake <cliff.brake@gmail.com>
- *  		<http://www.vibren.com> <http://bec-systems.com>
- *              Updated for 2.6 kernel
+ *  		<http://web.archive.org/web/*/http://www.vibren.com> 
+ *             <http://bec-systems.com> Updated for 2.6 kernel
  *
  */
 
-- 
1.7.2.1

