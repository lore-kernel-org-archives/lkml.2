Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab1LEMGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:06:25 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:60316 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab1LEMGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:06:23 -0500
Message-ID: <1323086778.4555.40.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] Remove invalid vi modeline
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 05 Dec 2011 13:06:18 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Opening lib/decompress_bunzip2.c with vim triggers this warning:
    "lib/decompress_bunzip2.c" 756L, 24002C
    Error detected while processing modelines:
    line    1:
    E521: Number required after =: sw =
    Press ENTER or type command to continue

1) Since the Linux kernel coding style disallows modelines this invalid
modeline can simply be removed. But perhaps you prefer a (series of)
patch(es) that removes all modelines. A quick grep of the tree suggests
that will be a lot of (tedious) work. But it's up to you, of course.

2) vim tested only.

 lib/decompress_bunzip2.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index a7b80c1..7ed5e32 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -1,4 +1,3 @@
-/* vi: set sw = 4 ts = 4: */
 /*	Small bzip2 deflate implementation, by Rob Landley (rob@landley.net).
 
 	Based on bzip2 decompression code by Julian R Seward (jseward@acm.org),
-- 
1.7.7.3

