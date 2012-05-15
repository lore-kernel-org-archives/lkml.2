Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab2EOQET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:04:19 -0400
Received: from ns.omikk.bme.hu ([152.66.114.1]:51524 "EHLO
	webmail.omikk.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933186Ab2EOQEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:04:14 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2012 12:04:14 EDT
Message-ID: <4FB27CC6.3050500@users.sourceforge.net>
Date: Tue, 15 May 2012 17:56:54 +0200
From: Jozsef Marton <jmarton@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
        torvalds@linux-foundation.org
Subject: [PATCH] Documentation: removed media from linux/Documentation/dontdiff
 to include changes under drivers/media
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jozsef Marton <jmarton@users.sourceforge.net>

Dontdiff patterns in linux/Documentation/dontdiff used to include media, so "diff -uprN -X linux/Documentation/dontdiff ..." as suggested to be used in linux/Documentation/SubmittingPatches did not examine changes under linux/drivers/media. Pattern has been removed.

Signed-off-by: Jozsef Marton <jmarton@users.sourceforge.net>
---
--- linux-3.4-rc7-vanilla/Documentation/dontdiff	2012-05-13 03:37:47.000000000 +0200
+++ linux-3.4-rc7/Documentation/dontdiff	2012-05-15 17:10:44.023622889 +0200
@@ -164,7 +164,6 @@ machtypes.h
 map
 map_hugetlb
 maui_boot.h
-media
 mconf
 miboot*
 mk_elfconfig
