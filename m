Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab2CaHnC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 03:43:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54774 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab2CaHm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 03:42:59 -0400
Date: Sat, 31 Mar 2012 00:42:41 -0700
From: tip-bot for David Miller <davem@davemloft.net>
Message-ID: <tip-3738d40ec51317eb8390218a33513ca35656f107@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, davem@davemloft.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, davem@davemloft.net
In-Reply-To: <20120327.000301.1122788061724345175.davem@davemloft.net>
References: <20120327.000301.1122788061724345175.davem@davemloft.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Do not include libgen.h
Git-Commit-ID: 3738d40ec51317eb8390218a33513ca35656f107
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 31 Mar 2012 00:42:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3738d40ec51317eb8390218a33513ca35656f107
Gitweb:     http://git.kernel.org/tip/3738d40ec51317eb8390218a33513ca35656f107
Author:     David Miller <davem@davemloft.net>
AuthorDate: Tue, 27 Mar 2012 00:03:01 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 27 Mar 2012 10:57:48 -0300

perf symbols: Do not include libgen.h

That causes us to end up using the XPG version of basename which can
modify it's argument.

Signed-off-by: David S. Miller <davem@davemloft.net>
Link: http://lkml.kernel.org/r/20120327.000301.1122788061724345175.davem@davemloft.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 5dd83c3..d9e995b 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1,6 +1,5 @@
 #include <dirent.h>
 #include <errno.h>
-#include <libgen.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
