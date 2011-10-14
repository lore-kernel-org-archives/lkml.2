Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab1JNTAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:00:40 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:44705 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab1JNTAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:00:39 -0400
Subject: [PATCH] [TRIVIAL] linux@lists.openrisc.net is moderated for
 non-subscribers
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 21:00:37 +0200
Message-ID: <1318618837.6132.116.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5483e0c..c7b1af5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4740,7 +4740,7 @@ K:	of_match_table
 OPENRISC ARCHITECTURE
 M:	Jonas Bonn <jonas@southpole.se>
 W:	http://openrisc.net
-L:	linux@lists.openrisc.net
+L:	linux@lists.openrisc.net (moderated for non-subscribers)
 S:	Maintained
 T:	git git://openrisc.net/~jonas/linux
 F:	arch/openrisc
-- 
1.7.4.4



