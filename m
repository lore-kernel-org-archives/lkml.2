Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab0IMTzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:55:32 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51542 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab0IMTzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mdt7RxVjRBc3wZxse3KawYnt1WtoFkK5pjqoUpjJFfXRXsO7H61Y6WVIiP85i/5Uyn
         rBHkl0Q/ym7tzwJHqzr7jJnVNtLlB5py677ff/llOc5MKQc+Q9S2sGlH6PLfi0vjn4Vu
         2j1DsEUoMpaknMal8bxsM2f9eHzDOfVhFBCm4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, mmarek@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH v2] scripts/kconfig/gconf.glade Update broken web addresses.
Date: Mon, 13 Sep 2010 12:55:56 -0700
Message-Id: <1284407756-4195-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed, remove the DOCTYPE declaration since libglade validates
the file against itself..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/kconfig/gconf.glade |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/gconf.glade b/scripts/kconfig/gconf.glade
index d52b0a7..aa483cb 100644
--- a/scripts/kconfig/gconf.glade
+++ b/scripts/kconfig/gconf.glade
@@ -1,5 +1,4 @@
 <?xml version="1.0" standalone="no"?> <!--*- mode: xml -*-->
-<!DOCTYPE glade-interface SYSTEM "http://glade.gnome.org/glade-2.0.dtd">
 
 <glade-interface>
 
-- 
1.7.2.1

