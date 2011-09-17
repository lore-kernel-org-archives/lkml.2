Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1IQOAP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 10:00:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39332 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab1IQOAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 10:00:14 -0400
MIME-Version: 1.0
In-Reply-To: <1316267014-10372-1-git-send-email-omycle@gmail.com>
References: <1316267014-10372-1-git-send-email-omycle@gmail.com>
Date: Sat, 17 Sep 2011 22:00:13 +0800
Message-ID: <CAFNq8R4N20tk82FxGK8iiV4A0iKEUWh30mjEtmnM+dHJ1bwQ+A@mail.gmail.com>
Subject: [PATCH] mm: Fix the comment the kunmap_high()
From: Li Haifeng <omycle@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the comment of kunmap_high()

Signed-off-by: Li Haifeng <omycle@gmail.com>
---
 mm/highmem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index 5ef672c..7b2e544 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -250,7 +250,7 @@ void *kmap_high_get(struct page *page)
 #endif

 /**
- * kunmap_high - map a highmem page into memory
+ * kunmap_high - unmap a highmem page from memory
 * @page: &struct page to unmap
 *
 * If ARCH_NEEDS_KMAP_HIGH_GET is not defined then this may be called
--
1.7.0.4
