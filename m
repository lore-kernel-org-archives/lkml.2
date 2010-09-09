Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab0IIWoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:44:17 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:53024 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933171Ab0IIWoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:44:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XFFC/Vuey6N3nTVdDmrtxxc0Oa+IEvkEnq881+Pa3CAgbkKJJHMpjYLjbpoOPmHt+7
         rRPxDdSvTRtkHczrhuWs+ZyKmpsuLZ6MUs8pbhL/SRIXOFnYsKMtQDFZkedUoFdjB8LT
         MNL3TMshneeVv0qlilG8PPBQloCf0GShM72P8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 193/223]drivers/staging/comedi/drivers/daqboard2000.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:44:11 -0700
Message-Id: <1284072253-8390-13-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284072253-8390-1-git-send-email-justinmattock@gmail.com>
References: <1284072253-8390-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/comedi/drivers/daqboard2000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 6af6c83..d3c9dbc 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -51,7 +51,7 @@ Configuration options:
    for the card, and here are the findings so far.
 
    1. A good document that describes the PCI interface chip is found at:
-      http://plx.plxtech.com/download/9080/databook/9080db-106.pdf
+      http://plx.plxtech.com/
 
    2. The initialization done so far is:
         a. program the FPGA (windows code sans a lot of error messages)
-- 
1.7.2.1

