Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab1B0Ees (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:34:48 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40844 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab1B0Eem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:34:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=p2/QjfWWW/V+SomD3CBk06Ej8o2gEaK7ttMU7mEiawZasZ1VaLTHVXW0DbfnDyrPln
         vTjxkmVHjIB5KupENrSVh4Nt29a8EYvizYNKPZcCNLx4xb12z2SNpUrZhhcLXQKWjRlg
         NOx13CCfC4dMrzBMHmhxBcXs0aImf3M69DniQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Rene Sapiens <rene.sapiens@ti.com>, devel@driverdev.osuosl.org
Subject: [PATCH 07/17]drivers:staging:dspbridge:node.h Remove one to many n's in a word.
Date: Sat, 26 Feb 2011 20:34:00 -0800
Message-Id: <1298781250-2718-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch below removes one to many "n's" in a word..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Rene Sapiens <rene.sapiens@ti.com>
CC: devel@driverdev.osuosl.org
  
---
 .../staging/tidspbridge/include/dspbridge/node.h   |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/node.h b/drivers/staging/tidspbridge/include/dspbridge/node.h
index 49ed5c1..8414e22 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/node.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/node.h
@@ -134,7 +134,7 @@ extern int node_close_orphans(struct node_mgr *hnode_mgr,
  *  ======== node_connect ========
  *  Purpose:
  *      Connect two nodes on the DSP, or a node on the DSP to the GPP. In the
- *      case that the connnection is being made between a node on the DSP and
+ *      case that the connection is being made between a node on the DSP and
  *      the GPP, one of the node handles (either node1 or node2) must be
  *      the constant NODE_HGPPNODE.
  *  Parameters:
-- 
1.7.4.1

