Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab0CYRY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:24:28 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:35786 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab0CYRX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:23:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Zw1fTktWZ7co3nv19zttgRGoULmsWwG3C6BWn826L+ZBsfzsWKfoIMF5fUm9GjIwga
         AKkEVp6RNULyol5M10Ij4Vz1GZ2M8QByTaLoD3JUCYmter351jC24XcyLYeYz/r7BTVr
         p0neE3x99srIYtl8rM6HgWsw1UHmsPhHpVyQ0=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-doc@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/16] Scripts lex.c: remove extra spaces
Date: Thu, 25 Mar 2010 18:22:42 +0100
Message-Id: <1269537767-7553-12-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.3.296.g9776a
In-Reply-To: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/genksyms/lex.c: deleted extra spaces

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 scripts/genksyms/lex.c_shipped |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/genksyms/lex.c_shipped b/scripts/genksyms/lex.c_shipped
index 2ac23bc..5682dfd 100644
--- a/scripts/genksyms/lex.c_shipped
+++ b/scripts/genksyms/lex.c_shipped
@@ -27,7 +27,7 @@
 /* %endif */
 
 /* %if-c-only */
-    
+
 /* %endif */
 
 /* %if-c-only */
-- 
1.7.0.3.296.g9776a

