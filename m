Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab0ISNV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 09:21:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64279 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab0ISNV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 09:21:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Sn/OFvrESire6FIVhJTT4oFfQZtCSFgb1KjGFS7uRpgJHu2tTZV5Oid48C81M1U3J5
         FfwpV6x72gvn9ADzwCUtAqK1e8ZETYzfKMKneEC45Q96ytnzDNeAzOX8easPMSTuaGQt
         qYWzRXdKDYgPmkK/A/aEeeOOxSvUGhcN1dD/A=
MIME-Version: 1.0
Date: Sun, 19 Sep 2010 21:21:56 +0800
Message-ID: <AANLkTi=Fi0i4fjWWaiZ_7E7FSOHqKKCfm9cxD3gLDLZe@mail.gmail.com>
Subject: [PATCH] Documemtation: fix email-clients for gmail
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If this patch is not unapplyable, then gmail seems not bad for
delivering patch to vger.kernel.org.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- o/linux-2.6.36-rc4/Documentation/email-clients.txt	2010-09-13
07:07:38.000000000 +0800
+++ m/linux-2.6.36-rc4/Documentation/email-clients.txt	2010-09-19
21:14:16.000000000 +0800
@@ -216,14 +216,6 @@ Works.  Use "Insert file..." or external
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Gmail (Web GUI)

-Does not work for sending patches.
-
-Gmail web client converts tabs to spaces automatically.
-
-At the same time it wraps lines every 78 chars with CRLF style line breaks
-although tab2space problem can be solved with external editor.
-
-Another problem is that Gmail will base64-encode any message that has a
-non-ASCII character. That includes things like European names.
+Works.  Instead of Rich formatting, select Plain Text when preparing patch.

                                 ###
