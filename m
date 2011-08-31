Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab1HaWax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 18:30:53 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:64527 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757199Ab1HaWaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 18:30:46 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (PLAIN)
X-Authority-Analysis: v=1.1 cv=QcSFu2tMqX8VyBnwf4xZriMeG3TVj1s8v1Rcea0EwGI= c=1 sm=0 a=eBnEfeSLl9YA:10 a=DGNUU6r2KE0A:10 a=ozIaqLvjkoIA:10 a=8nJEP1OIZ-IA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=YORvzBCaAAAA:8 a=iLNU1ar6AAAA:8 a=azj6Gt-4AAAA:8 a=uax-E2x3XU4ud6HVRKIA:9 a=LG2hbd1Lh7TaUH3jwdQA:7 a=wPNLvfGTeEIA:10 a=VV2__AUApEoA:10 a=-XwJ49_kmwcA:10 a=eJ1lpvm07AkA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
Message-ID: <4E5EB614.9040600@systemfabricworks.com>
Date: Wed, 31 Aug 2011 17:30:44 -0500
From: Bob Pearson <rpearson@systemfabricworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: fzago@systemfabricworks.com, rpearson@systemfabricworks.com,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        George Spelvin <linux@horizon.com>, akpm@linux-foundation.org
Subject: [PATCH v6 10/10] crc32-final.diff
References: <20110831213729.395283830@systemfabricworks.com>
In-Reply-To: <20110831213729.395283830@systemfabricworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some final changes
	- added a comment at the top of crc32.c

Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>

---
 lib/crc32.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: for-next/lib/crc32.c
===================================================================
--- for-next.orig/lib/crc32.c
+++ for-next/lib/crc32.c
@@ -1,4 +1,8 @@
 /*
+ * Aug 8, 2011 Bob Pearson with help from Joakim Tjernlund and George Spelvin
+ * cleaned up code to current version of sparse and added the slicing-by-8
+ * algorithm to the closely similar existing slicing-by-4 algorithm.
+ *
  * Oct 15, 2000 Matt Domsch <Matt_Domsch@dell.com>
  * Nicer crc32 functions/docs submitted by linux@horizon.com.  Thanks!
  * Code was from the public domain, copyright abandoned.  Code was


