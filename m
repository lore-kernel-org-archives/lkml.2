Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab2K2QbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 11:31:19 -0500
Received: from anubis.se.axis.com ([195.60.68.12]:33823 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2K2QbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 11:31:18 -0500
Date: Thu, 29 Nov 2012 17:31:16 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: linux-cifs@vger.kernel.org, sfrench@samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Add handling of blank password option
Message-ID: <20121129163116.GP27196@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The option to have a blank "pass=" already exists, and with
a password specified both "pass=%s" and "password=%s" are supported.
Also, both blank "user=" and "username=" are supported, making
"password=" the odd man out.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5c670b9..c83f5b65 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -186,6 +186,7 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_user, "user=%s" },
 	{ Opt_user, "username=%s" },
 	{ Opt_blank_pass, "pass=" },
+	{ Opt_blank_pass, "password=" },
 	{ Opt_pass, "pass=%s" },
 	{ Opt_pass, "password=%s" },
 	{ Opt_blank_ip, "ip=" },
-- 
1.8.0.rc0.18.gf84667d


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
