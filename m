Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab2HJOGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:06:35 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:52959 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746Ab2HJOGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:06:30 -0400
From: Marina Makienko <makienko@ispras.ru>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Marina Makienko <makienko@ispras.ru>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: [PATCH] target: Add blk_put_request()
Date: Fri, 10 Aug 2012 18:02:35 +0400
Message-Id: <1344607355-9310-1-git-send-email-makienko@ispras.ru>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1344585899-31466-1-git-send-email-makienko@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk requests are obtained (some memory is allocated for them)
by means of functions blk_get_request and blk_make_request.
After usage (usually with help of blk_execute_rq) these requests
should be put (and freed) with help of blk_put_request.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Marina Makienko <makienko@ispras.ru>
---
There is no problems in drivers/target/target_core_pscsi.c

Please ignore the previous message. 
-- 
1.7.7

