Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab2C0EDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 00:03:14 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37651 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2C0EDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 00:03:13 -0400
Date: Tue, 27 Mar 2012 00:03:01 -0400 (EDT)
Message-Id: <20120327.000301.1122788061724345175.davem@davemloft.net>
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Do not include libgen.h
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 26 Mar 2012 21:03:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


That causes us to end up using the XPG version of basename which can
modify it's argument.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 tools/perf/util/symbol.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 472b467..c0a028c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1,6 +1,5 @@
 #include <dirent.h>
 #include <errno.h>
-#include <libgen.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
-- 
1.7.9.1

