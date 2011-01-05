Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab1AETTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 14:19:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38940 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab1AETTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 14:19:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=Zmc1aOsGxc6th+yDTPUtZbVLjWXGD4sPmXPiC6AvqLPfwdjEXyUuCQaJSX8UcwLBfQ
         eD3ERTkq6o8UFvQS57K2INKeY+A+z3Xd9gIe3+dgneMLF0qMG9HP93TTYP6qs1v0r48m
         CqZHZEfMBXx+VhjTSJ8WD8EofAelbm5lZGhms=
MIME-Version: 1.0
Date: Wed, 5 Jan 2011 22:19:47 +0300
X-Google-Sender-Auth: 8lc4tTHBf9F75ikducU97k8ZJxE
Message-ID: <AANLkTi=s_DvRRnDuzw96MMYmykhOYtOh0TJ4pBaR9GKj@mail.gmail.com>
Subject: [PATCH 2/2] do_mounts: Small style cleanup in match_dev_by_uuid
From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Kirill Smelkov <kirr@landau.phys.spbu.ru>, kirr@mns.spb.ru,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Smelkov <kirr@landau.phys.spbu.ru>

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
---
 init/do_mounts.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 1315e8d..c75dbd5 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -75,7 +75,7 @@ static int match_dev_by_uuid(struct device *dev, void *data)
 		goto no_match;

 	if (memcmp(uuid, part->info->uuid, sizeof(part->info->uuid)))
-			goto no_match;
+		goto no_match;

 	return 1;
 no_match:
-- 
1.7.3.4.626.g73e7b
