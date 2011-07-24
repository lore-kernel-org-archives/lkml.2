Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1GXKSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 06:18:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63940 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1GXKSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 06:18:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAPA4HGVYuZ3S+OxU9dXgPuqk1ERrYNshUe27M8QmN7c4+B7LAA@mail.gmail.com>
References: <CAPA4HGVYuZ3S+OxU9dXgPuqk1ERrYNshUe27M8QmN7c4+B7LAA@mail.gmail.com>
Date: Sun, 24 Jul 2011 12:18:09 +0200
X-Google-Sender-Auth: 7k9C3jKZw_2-rnZj0V8PL4vSOUY
Message-ID: <CAPA4HGUHLDDTtaJ28jXNtRFJ6005=ZsQJa10TpoQmV_QxhYVPA@mail.gmail.com>
Subject: Re: [PATCH 2/2] docs: update the development process document.
From: Luis de Bethencourt <luis@debethencourt.com>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <greg@kroah.com>,
        Andres Salomon <dilinger@queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Here's a set of changes updating Documentation/development-process.
    I have update kernel releases.

Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
---
 Documentation/development-process/2.Process |   36 +++++++++++++++------------
 1 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/Documentation/development-process/2.Process
b/Documentation/development-process/2.Process
index 4823577..2d79ddb 100644
--- a/Documentation/development-process/2.Process
+++ b/Documentation/development-process/2.Process
@@ -14,6 +14,7 @@ The kernel developers use a loosely time-based
release process, with a new
 major kernel release happening every two or three months.  The recent
 release history looks like this:

+	2.6.39	May 18, 2011
 	2.6.38	March 14, 2011
 	2.6.37	January 4, 2011
 	2.6.36	October 20, 2010
@@ -65,19 +66,18 @@ will get up to somewhere between -rc6 and -rc9
before the kernel is
 considered to be sufficiently stable and the final 2.6.x release is made.
 At that point the whole process starts over again.

-As an example, here is how the 2.6.38 development cycle went (all dates in
+As an example, here is how the 2.6.39 development cycle went (all dates in
 2011):

-	January 4	2.6.37 stable release
-	January 18	2.6.38-rc1, merge window closes
-	January 21	2.6.38-rc2
-	February 1	2.6.38-rc3
-	February 7	2.6.38-rc4
-	February 15	2.6.38-rc5
-	February 21	2.6.38-rc6
-	March 1		2.6.38-rc7
-	March 7		2.6.38-rc8
 	March 14	2.6.38 stable release
+	March 29	2.6.39-rc1, merge window closes
+	April 6		2.6.39-rc2
+	April 12	2.6.39-rc3
+	April 19	2.6.39-rc4
+	April 27	2.6.39-rc5
+	May 4		2.6.39-rc6
+	May 10		2.6.39-rc7
+	May 18		2.6.39 stable release

 How do the developers decide when to close the development cycle and create
 the stable release?  The most significant metric used is the list of
@@ -103,13 +103,17 @@ numbering scheme.  To be considered for an
update release, a patch must (1)
 fix a significant bug, and (2) already be merged into the mainline for the
 next development kernel.  Kernels will typically receive stable updates for
 a little more than one development cycle past their initial release.  So,
-for example, the 2.6.36 kernel's history looked like:
+for example, the 2.6.38 kernel's history looked like:

-	October 10	2.6.36 stable release
-	November 22	2.6.36.1
-	December 9	2.6.36.2
-	January 7	2.6.36.3
-	February 17	2.6.36.4
+	March 14	2.6.38 stable release
+	March 23	2.6.38.1
+	March 27	2.6.38.2
+	April 14	2.6.38.3
+	April 21	2.6.38.4
+	May 2		2.6.38.5
+	May 9		2.6.38.6
+	May 21		2.6.38.7
+	June 3		2.6.38.8

 2.6.36.4 was the final stable update for the 2.6.36 release.

-- 
1.7.5.3
