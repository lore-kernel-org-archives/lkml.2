Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab1HDCAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 22:00:05 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:56678 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab1HDB76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 21:59:58 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Aug 2011 21:59:57 EDT
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 1/2] kconfig/nconf: nuke unreferenced `nohelp_text'
Date: Wed,  3 Aug 2011 21:52:06 -0400
Message-Id: <1312422727-9740-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 5416857867c9cc94aba641898c567d9707de30f1, 1nohelp_text' is no
longer referenced, nuke it.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/nconf.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 39ca1f1..b113c50 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -182,8 +182,6 @@ setmod_text[] = N_(
 "This feature depends on another which\n"
 "has been configured as a module.\n"
 "As a result, this feature will be built as a module."),
-nohelp_text[] = N_(
-"There is no help available for this option.\n"),
 load_config_text[] = N_(
 "Enter the name of the configuration file you wish to load.\n"
 "Accept the name shown to restore the configuration you\n"
-- 
1.7.6.153.g78432

