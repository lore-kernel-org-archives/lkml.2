Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab2AMEKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 23:10:18 -0500
Received: from mx2.netapp.com ([216.240.18.37]:4850 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756919Ab2AMEKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 23:10:15 -0500
X-IronPort-AV: E=Sophos;i="4.71,502,1320652800"; 
   d="scan'208";a="616284572"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] scsi : Adding all the definitions of host bytes in hostbyte_table
Date: Thu, 12 Jan 2012 23:10:02 -0500
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD910F3C0A6@RTPMVEXC1-PRD.hq.netapp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH] scsi : Adding all the definitions of host bytes in hostbyte_table
thread-index: AczRqTju1CsRbHcrTVaN+Wzn9/npYQ==
From: "Moger, Babu" <Babu.Moger@netapp.com>
To: <linux-kernel@vger.kernel.org>
Cc: "device-mapper development" <dm-devel@redhat.com>
X-OriginalArrivalTime: 13 Jan 2012 04:10:05.0300 (UTC) FILETIME=[3ACB9340:01CCD1A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding all the definitions of host bytes in hostbyte_table.

Without this patch, scsi_show_result prints hostbyte as invalid
for statuses that are not defined in hostbyte_table(when scsi logging is enabled).

Look at scsi_print_result function for better understanding.

Signed-off-by: Babu Moger <babu.moger@netapp.com>
---
--- linux-3.1-rc4/drivers/scsi/constants.c.orig	2012-01-12 15:21:28.000000000 -0600
+++ linux-3.1-rc4/drivers/scsi/constants.c	2012-01-12 15:25:07.000000000 -0600
@@ -1422,7 +1422,8 @@ static const char * const hostbyte_table
 "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET",
 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
 "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_REQUEUE",
-"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST" };
+"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST", "DID_TARGET_FAILURE",
+"DID_NEXUS_FAILURE" };
 #define NUM_HOSTBYTE_STRS ARRAY_SIZE(hostbyte_table)
 
 static const char * const driverbyte_table[]={


