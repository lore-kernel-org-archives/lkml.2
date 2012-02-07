Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab2BGOrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:47:42 -0500
Received: from service87.mimecast.com ([91.220.42.44]:54393 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2BGOrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:47:41 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jim Cromie <jim.cromie@gmail.com>, Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] params: Add missing init level name
Date: Tue,  7 Feb 2012 14:45:04 +0000
Message-Id: <1328625904-3505-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <87liofip4d.fsf@rustcorp.com.au>
References: <87liofip4d.fsf@rustcorp.com.au>
X-OriginalArrivalTime: 07 Feb 2012 14:45:28.0551 (UTC) FILETIME=[2259C770:01CCE5A7]
X-MC-Unique: 112020714453312201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q17ElsFQ028883

The initcall_level_names array did not contain name of the
"virtual" level 0 (early paramters). Fixed.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 init/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/init/main.c b/init/main.c
index 8e4060c..b229ee6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -726,6 +726,7 @@ static initcall_t *initcall_levels[] __initdata = {
 };
 
 static char *initcall_level_names[] __initdata = {
+	"early parameters",
 	"core parameters",
 	"postcore parameters",
 	"arch parameters",
-- 
1.7.5.4


