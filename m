Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0IKFrQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 01:47:16 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55473 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab0IKFpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 01:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=T2zWe425HvSRDSh9eOY7U/bFN+DFSmjjeh4A2081VbeDLJlYkGzbbxJIQwBlwUN2HE
         jNWrfiXwGVQFDZg2bBXXKfYxwGjm0tPUjPDLdLmvqfQ0hiCuVGWwIP2aSEUfNb+I/qQ+
         +v/H2L6XnTDVo2KazyrV2UC8VxPIDXjChkdXc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 03/11]net/ipv4/cipso_ipv4.c Update broken web addresses.
Date: Fri, 10 Sep 2010 22:45:55 -0700
Message-Id: <1284183963-8474-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284183963-8474-1-git-send-email-justinmattock@gmail.com>
References: <1284183963-8474-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 net/ipv4/cipso_ipv4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 3a92a76..65dc808 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -9,7 +9,7 @@
  *
  * The CIPSO draft specification can be found in the kernel's Documentation
  * directory as well as the following URL:
- *   http://netlabel.sourceforge.net/files/draft-ietf-cipso-ipsecurity-01.txt
+ *  http://tools.ietf.org/id/draft-ietf-cipso-ipsecurity-01.txt 
  * The FIPS-188 specification can be found at the following URL:
  *   http://www.itl.nist.gov/fipspubs/fip188.htm
  *
-- 
1.7.2.1

