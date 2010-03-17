Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab0CQSwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 14:52:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:54551 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751595Ab0CQSwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 14:52:22 -0400
X-Authenticated: #34473864
X-Provags-ID: V01U2FsdGVkX19sd8Zo1UBsd8ExDlbKZXFIWZ3AO5o2QCtf3+6qz/
	DXZ/HneHAdORXk
Message-ID: <4BA124DC.2070701@gmx.de>
Date: Wed, 17 Mar 2010 19:52:12 +0100
From: Philipp Kohlbecher <xt28@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Shredder/3.0.3
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] .gitignore: ignore *.lzo files
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68999999999999995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore files compressed with lzop.

Signed-off-by: Philipp Kohlbecher <xt28@gmx.de>
---
 .gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index a2939fc..8faa6c0 100644
--- a/.gitignore
+++ b/.gitignore
@@ -28,6 +28,7 @@ modules.builtin
 *.gz
 *.bz2
 *.lzma
+*.lzo
 *.patch
 *.gcno

-- 
1.7.0.2
