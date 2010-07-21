Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab0GUE6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:58:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51532 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933429Ab0GUE5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:57:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OYIHwhCI5o0O5MtDkak7ksZV+EFFd7LSa3q9OT0AHA87un6DkE4zCg/XK/BQmXvV62
         oBsDq73I4sVfEUSwjqVJ7xRVE2SSgdzADihyK8YmI8l4iCih1O8cvQfzqrnRaspzeso4
         bGi+BQBfd4+dzHN8E9vxTyz3Z7QZFcPgPxYBY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 100/100]Documentation/scsi/osst.txt update web address.
Date: Tue, 20 Jul 2010 21:56:50 -0700
Message-Id: <1279688215-29628-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
References: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/scsi/osst.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/scsi/osst.txt b/Documentation/scsi/osst.txt
index 2b21890..ad86c6d 100644
--- a/Documentation/scsi/osst.txt
+++ b/Documentation/scsi/osst.txt
@@ -135,7 +135,7 @@ The driver development is coordinated through a mailing list
 a CVS repository and some web pages. 
 The tester's pages which contain recent news and updated drivers to download
 can be found on
-http://linux1.onstream.nl/test/
+http://sourceforge.net/projects/osst/
 
 If you find any problems, please have a look at the tester's page in order
 to see whether the problem is already known and solved. Otherwise, please
-- 
1.7.1.rc1.21.gf3bd6

