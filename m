Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab1IMK3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:29:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53215 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab1IMK3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:29:50 -0400
Message-ID: <4E6F3091.1060701@gmail.com>
Date: Tue, 13 Sep 2011 18:29:37 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        NeilBrown <neilb@suse.de>, Jonathan Brassow <jbrassow@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cleanup: fix the comment for field num_discard_requests of
 struct dm_target
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is against 3.1-rc6

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 include/linux/device-mapper.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 3fa1f3d..a54aba2 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -182,7 +182,8 @@ struct dm_target {
 
 	/*
 	 * The number of discard requests that will be submitted to the
-	 * target.  map_info->request_nr is used just like num_flush_requests.
+	 * target. map_info->target_request_nr is used just like
+	 * num_flush_requests.
 	 */
 	unsigned num_discard_requests;
 
-- 
1.7.1

