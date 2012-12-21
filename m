Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab2LUEMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 23:12:10 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:38377 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2LUEMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 23:12:05 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-e9-50d3e1947b36
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Subject: [PATCH] f2fs: add MAINTAINERS entry
Date: Fri, 21 Dec 2012 13:11:51 +0900
Message-id: <1356063111-22007-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.0.1.250.gb7973fb
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zfd0pDy8HGEy5w2OxZ+9JFovLu+aw
	OTB5fN4kF8AYxWWTkpqTWZZapG+XwJUx9+E2toLLbBUfD/1kbmC8ytrFyMkhIWAi8X3XByhb
	TOLCvfVsXYxcHEICyxgl3sz7zgRT9LzlFTNEYjqjxMrlz9hBEkICLUwSk95adjFycLAJaEts
	3m8AEhYRyJQ4snIGK0iYWUBTYsaTOpCwsICORPuclSwgNouAqsTmW0vBbF4Bd4mGSeuYQcol
	BHQlpm4WgSgRkPg2+RALRFhWYtMBsAMkBA6wSXx7c5gZ4jJJiYMrbrBMYBRcwMiwilE0tSC5
	oDgpPddQrzgxt7g0L10vOT93EyMkrKR2MK5ssDjEKMDBqMTDy2h2OUCINbGsuDL3EKMEB7OS
	CO/zJUAh3pTEyqrUovz4otKc1OJDjD5Al0xklhJNzgeGfF5JvKGxsYmZiamJuaWpuSkOYSVx
	3maPlAAhgfTEktTs1NSC1CKYcUwcnFINjEyrDpq961soFBBxVmnCRYnqmK72G87+p20cQi75
	CLmd3F1jxMQk9GfiuQOMXLNuzZL5cMNWY2rwjuYTLzxZjmy7VNAfGLhypQyvXaT18Tcy6XJ7
	r/aZSW6oN9w63XtvwXnJj34NWlHzdkRmcQRoBi2xr+XdkD9/USfDOS/fplNFYaaKd/gWKbEU
	ZyQaajEXFScCAE2fvKpYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t9jQd0pDy8HGOyZyGGxZ+9JFovLu+aw
	OTB5fN4kF8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQM0WkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYMffhNraCy2wV
	Hw/9ZG5gvMraxcjJISFgIvG85RUzhC0mceHeerYuRi4OIYHpjBIrlz9jB0kICbQwSUx6a9nF
	yMHBJqAtsXm/AUhYRCBT4sjKGawgYWYBTYkZT+pAwsICOhLtc1aygNgsAqoSm28tBbN5Bdwl
	GiatYwYplxDQlZi6WWQCI/cCRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFB+0xqB+PK
	BotDjAIcjEo8vIxmlwOEWBPLiitzDzFKcDArifA+XwIU4k1JrKxKLcqPLyrNSS0+xOgDtHwi
	s5Rocj4wovJK4g2NTcyMLI3MLIxMzM1xCCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi4JRqYJy1
	Wog/wcaQjcfpYv/x0tyNTFbpb90tw3aqPlzs8nk2h9V9RzaBQ+fOzea59lZptuKhQtcff5kU
	T3ptfXZTZp1CzfIOk/CC3c3yD3ZoF7CfYndbvsEhaMp5pewmh1N9K/sXnI03dOfjW/Xown5x
	syj5Dyvtclz4CyZvV/qtcHLJ2n/RdjJtmkosxRmJhlrMRcWJAB+npc+HAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds myself to MAINTAINERS entry for the f2fs file system.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9386a63..f15d168 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3204,6 +3204,16 @@ F:	Documentation/filesystems/caching/
 F:	fs/fscache/
 F:	include/linux/fscache*.h
 
+F2FS FILE SYSTEM
+M:	Jaegeuk Kim <jaegeuk.kim@samsung.com>
+L:	linux-f2fs-devel@lists.sourceforge.net
+W:	http://en.wikipedia.org/wiki/F2FS
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git
+S:	Maintained
+F:	Documentation/filesystems/f2fs.txt
+F:	fs/f2fs/
+F:	include/linux/f2fs_fs.h
+
 FUJITSU FR-V (FRV) PORT
 M:	David Howells <dhowells@redhat.com>
 S:	Maintained
-- 
1.8.0.1.250.gb7973fb

