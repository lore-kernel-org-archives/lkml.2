Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab0IKE1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 00:27:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55211 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab0IKE1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 00:27:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ry+1O5wbKP4RplABuYCe6a315dkCbZ3ehpSvX9KxghwsfFAJsltq0J1qqV+GPDcze8
         bxi9o4oN2frNimWHXQl/mL0aU4qBoy8vPW5KxZwiQDL7VD+84B54Wl4lcXUNXHjon1zO
         qVN3MiHeBCLPhJKU6RWOkauOLF2o+GepaYXvU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 02/10]include/crypto/gf128mul.h Update broken web addresses.
Date: Fri, 10 Sep 2010 21:27:49 -0700
Message-Id: <1284179277-7788-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284179277-7788-1-git-send-email-justinmattock@gmail.com>
References: <1284179277-7788-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 include/crypto/gf128mul.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/crypto/gf128mul.h b/include/crypto/gf128mul.h
index 4086b8e..7021c6c 100644
--- a/include/crypto/gf128mul.h
+++ b/include/crypto/gf128mul.h
@@ -4,7 +4,7 @@
  * Copyright (c) 2006 Rik Snel <rsnel@cube.dyndns.org>
  *
  * Based on Dr Brian Gladman's (GPL'd) work published at
- * http://fp.gladman.plus.com/cryptography_technology/index.htm
+ * http://www.gladman.me.uk/ 
  * See the original copyright notice below.
  *
  * This program is free software; you can redistribute it and/or modify it
@@ -54,8 +54,8 @@
 
 /* Comment by Rik:
  *
- * For some background on GF(2^128) see for example: http://-
- * csrc.nist.gov/CryptoToolkit/modes/proposedmodes/gcm/gcm-revised-spec.pdf
+ * For some background on GF(2^128) see for example: 
+ * http://www.cryptobarn.com/papers/gcm-spec.pdf 
  *
  * The elements of GF(2^128) := GF(2)[X]/(X^128-X^7-X^2-X^1-1) can
  * be mapped to computer memory in a variety of ways. Let's examine
-- 
1.7.2.1

