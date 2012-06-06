Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494Ab2FFVMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:12:51 -0400
Received: from ns.omikk.bme.hu ([152.66.114.1]:42201 "EHLO
	webmail.omikk.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab2FFVMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:12:49 -0400
Message-ID: <4FCFC7C3.3080603@users.sourceforge.net>
Date: Wed, 06 Jun 2012 23:12:35 +0200
From: Jozsef Marton <jmarton@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120506 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>, Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
        torvalds@linux-foundation.org, Jean-Francois Moine <moinejf@free.fr>
Subject: [PATCH] Documentation: removed media from linux/Documentation/dontdiff
 to include changes under drivers/media
References: <4FB27CC6.3050500@users.sourceforge.net>
In-Reply-To: <4FB27CC6.3050500@users.sourceforge.net>
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
