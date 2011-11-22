Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab1KVW2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:28:39 -0500
Received: from smtp.outflux.net ([198.145.64.163]:37233 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab1KVW2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:28:38 -0500
Date: Tue, 22 Nov 2011 14:27:44 -0800
From: Kees Cook <kees@outflux.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] CREDITS: update expired fingerprint and fix details
Message-ID: <20111122222744.GA26634@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small clean-up for my CREDITS entry; the GPG fingerprint was not up to
date, so I fixed other details at the same time too.

Signed-off-by: Kees Cook <kees@outflux.net>
---
 CREDITS |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/CREDITS b/CREDITS
index 07e32a8..44fce98 100644
--- a/CREDITS
+++ b/CREDITS
@@ -688,10 +688,13 @@ S: Oxfordshire, UK.
 
 N: Kees Cook
 E: kees@outflux.net
-W: http://outflux.net/
-P: 1024D/17063E6D 9FA3 C49C 23C9 D1BC 2E30  1975 1FFF 4BA9 1706 3E6D
-D: Minor updates to SCSI types, added /proc/pid/maps protection
+E: kees@ubuntu.com
+E: keescook@chromium.org
+W: http://outflux.net/blog/
+P: 4096R/DC6DC026 A5C3 F68F 229D D60F 723E  6E13 8972 F4DF DC6D C026
+D: Various security things, bug fixes, and documentation.
 S: (ask for current address)
+S: Portland, Oregon
 S: USA
 
 N: Robin Cornelius
-- 
1.7.0.4

