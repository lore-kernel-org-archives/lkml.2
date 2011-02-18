Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1BRGeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 01:34:07 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39610 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab1BRGeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 01:34:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dtvREXsHOffCSHhwPMSzVEzXKeSKoJTD4qMJRmEeQbukz9VYv83L/nJiq/t/6SKaG6
         IOnb5dLhaWC/+06Fhs3XhyOnFAJIjkWL+XU+K2se/aYuzBAuIQScUmnAvwCRxTyNqDR6
         YzHrm/fgehEE5p4orwoWfR0xqKo1tJ9vXwrAc=
From: Dustan Bower <dustan.bower@gmail.com>
To: gregkh@suse.de
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dustan Bower <dustan.bower@gmail.com>
Subject: [PATCH] Staging: comedi: drivers.c: fixed braces coding style issue.
Date: Fri, 18 Feb 2011 01:32:08 -0500
Message-Id: <1298010728-7036-1-git-send-email-dustan.bower@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue.

Signed-off-by: Dustan Bower <dustan.bower@gmail.com>
---
 drivers/staging/comedi/drivers.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index dca861e..f8b91b7 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -471,9 +471,8 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 
 		async->buf_page_list =
 		    vzalloc(sizeof(struct comedi_buf_page) * n_pages);
-		if (async->buf_page_list) {
+		if (async->buf_page_list)
 			pages = vmalloc(sizeof(struct page *) * n_pages);
-		}
 		if (pages) {
 			for (i = 0; i < n_pages; i++) {
 				if (s->async_dma_dir != DMA_NONE) {
-- 
1.7.4.1

