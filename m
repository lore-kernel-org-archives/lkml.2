Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab1IARxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 13:53:17 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50115 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab1IARxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 13:53:15 -0400
From: crquan@gmail.com
To: linux-kbuild@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Nir Tzachar <nir.tzachar@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        c.rq541@comcast.net
Subject: [PATCH V3 1/5] scripts/kconfig/nconf: fix typo: unknow => unknown
Date: Thu,  1 Sep 2011 10:52:18 -0700
Message-Id: <1314899542-5848-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <CAH5vBdKxbaKDrA2gAj5CoDYShN+5dnfu6Bmd=4+oV-XmnYQnFA@mail.gmail.com>
References: <CAH5vBdKxbaKDrA2gAj5CoDYShN+5dnfu6Bmd=4+oV-XmnYQnFA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

Signed-off-by: Cheng Renquan <crquan@gmail.com>
Acked-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/nconf.gui.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
index f8137b3..d3af04e 100644
--- a/scripts/kconfig/nconf.gui.c
+++ b/scripts/kconfig/nconf.gui.c
@@ -461,7 +461,7 @@ int dialog_inputbox(WINDOW *main_window,
 				result[cursor_position] = res;
 				cursor_position++;
 			} else {
-				mvprintw(0, 0, "unknow key: %d\n", res);
+				mvprintw(0, 0, "unknown key: %d\n", res);
 			}
 			break;
 		}
-- 
1.7.6

