Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab0GUExS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:53:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40697 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab0GUEwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:52:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UYTsIsGedtAh8ATvKEtWtrL45WAs4fh/iCMDkaLCy3m8V+2kcDwItHGL02+lEYmOZC
         miC9AmpA0VtZLPuOdRi/H4eTL2Nnsgovvel06m8V3fg1TWxU8mZ56z5hse+unkAvUo/G
         Qm7ZCaQOOKSJ6c4AECh7E7WG1vwoz7X8IBHwg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 29/29]Documentation/filesystems/isofs.txt update web address.
Date: Tue, 20 Jul 2010 21:52:05 -0700
Message-Id: <1279687926-29360-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
References: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/filesystems/isofs.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/isofs.txt b/Documentation/filesystems/isofs.txt
index 3c367c3..ba0a933 100644
--- a/Documentation/filesystems/isofs.txt
+++ b/Documentation/filesystems/isofs.txt
@@ -41,7 +41,7 @@ Mount options unique to the isofs filesystem.
   sbsector=xxx  Session begins from sector xxx
 
 Recommended documents about ISO 9660 standard are located at:
-http://www.y-adagio.com/public/standards/iso_cdromr/tocont.htm
+http://www.y-adagio.com/
 ftp://ftp.ecma.ch/ecma-st/Ecma-119.pdf
 Quoting from the PDF "This 2nd Edition of Standard ECMA-119 is technically 
 identical with ISO 9660.", so it is a valid and gratis substitute of the
-- 
1.7.1.rc1.21.gf3bd6

