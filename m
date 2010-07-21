Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762473Ab0GUFKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:10:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62631 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933326Ab0GUE4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=slY8nX2sDX63gi9qaZ8JUYjgvpJQTd5GrQGDWwhQ1In4jTcKrYsBHNmeISwzEqR0Cl
         LZ4gPN4Yr2UYdt1WB//McHfakfGU7s8V3uPHKnq31u+DJcmNAnexX7FWEO9ZXS1LykAc
         6kX5/wY5cTX7pIFR7BKLmVSocJjKzD0Dbi3WY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 87/87]Documentation/networking/wavelan.txt update web address.
Date: Tue, 20 Jul 2010 21:55:50 -0700
Message-Id: <1279688153-29571-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
References: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an unused web address due to me not being
able to locate anything in the same vacinity.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/networking/wavelan.txt |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/Documentation/networking/wavelan.txt b/Documentation/networking/wavelan.txt
index afa6e52..4b82293 100644
--- a/Documentation/networking/wavelan.txt
+++ b/Documentation/networking/wavelan.txt
@@ -50,7 +50,6 @@ and a Lucent Modem, and NOT 802.11 compatible.
 -----------------
 	o Config :	Not yet in kernel
 	o Location :	Pcmcia package 3.1.10+
-	o on-line doc :	http://www.fasta.fh-dortmund.de/users/andy/wvlan/
 
 	This is the driver for the current generation of Wavelan IEEE,
 which is 802.11 compatible. Depending on version, it is 2 Mb/s or 11
-- 
1.7.1.rc1.21.gf3bd6

