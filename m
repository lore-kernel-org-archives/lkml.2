Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab1EGS5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 14:57:22 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:52682 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755983Ab1EGS5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 14:57:10 -0400
Date: Sat, 7 May 2011 20:55:49 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] thp: unbalanced parenthesis
Message-ID: <20110507205549.6bb0f49f@absol.kitzblitz>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
Untested.

 include/asm-generic/pgtable.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index b4bfe33..b80daee 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -88,7 +88,7 @@ static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm,
 	pmd_t pmd = *pmdp;
 	pmd_clear(mm, address, pmdp);
 	return pmd;
-})
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
-- 
1.7.5.rc3
