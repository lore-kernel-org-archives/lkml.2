Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab0FREkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 00:40:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56200 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab0FREkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 00:40:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qxjdrSttMNgsErN9kUj++XJ3OT/oAq+QHI1gyJrezlrWmaSZaPP4xRNiQ1o4eZXF0I
         JKAcT4DiA376/Pp1ItNisgeiWF6hhoyWJgc67OiXa7a7rGaNZP5H11TX2T3jSWwkaPnF
         atWSWOngmqNLp5xpMTvsq6z/bDNxKe9ah7rd4=
Subject: [PATCH] perf: Makefile fix for Perl scripting
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stephane Eranian <eranian@google.com>, mingo@elte.hu, fweisbec@gmail.com,
       acme@ghostprotocols.net
Content-Type: text/plain
Date: Thu, 17 Jun 2010 23:40:06 -0500
Message-Id: <1276836006.7762.15.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo introduced by recent Makefile changes.  Without it, Perl
scripting support won't get compiled in.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6aa2fe3..17a3692 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -577,7 +577,7 @@ ifdef NO_LIBPERL
 else
 	PERL_EMBED_LDOPTS = `perl -MExtUtils::Embed -e ldopts 2>/dev/null`
 	PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
-	PERL_EMBED_FLAGS=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
+	FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
 	ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED)),y)
 		BASIC_CFLAGS += -DNO_LIBPERL
-- 
1.6.4.GIT



