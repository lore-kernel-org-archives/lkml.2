Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab1D2Wj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:39:29 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:51402 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934047Ab1D2WjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:39:22 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DBB3DED.1060508@verizon.net>
Date: Fri, 29 Apr 2011 18:38:37 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH V2 7/7] kbuild: move docproc from scripts/basic to scripts
Content-Type: multipart/mixed;
	boundary="------------060505030808060802080608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------060505030808060802080608
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

This patch moves docproc from scripts/basic to scripts.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/{basic => }/docproc.c |    0
 1 files changed, 0 insertions(+), 0 deletions(-)
 rename scripts/{basic => }/docproc.c (100%)

diff --git a/scripts/basic/docproc.c b/scripts/docproc.c
similarity index 100%
rename from scripts/basic/docproc.c
rename to scripts/docproc.c
-- 
1.7.5.rc1



--------------060505030808060802080608
Content-Type: text/plain;
	name="kbuild-move-docproc-from-scripts-basic-to-scripts.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kbuild-move-docproc-from-scripts-basic-to-scripts.patch"

>From 0fa8bd8df499aa949f105408530fe06c96669d05 Mon Sep 17 00:00:00 2001
From: Peter Foley <pefoley2@verizon.net>
Date: Tue, 26 Apr 2011 19:25:31 -0400
Subject: [PATCH 7/7] kbuild: move docproc from scripts/basic to scripts


Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/{basic => }/docproc.c |    0
 1 files changed, 0 insertions(+), 0 deletions(-)
 rename scripts/{basic => }/docproc.c (100%)

diff --git a/scripts/basic/docproc.c b/scripts/docproc.c
similarity index 100%
rename from scripts/basic/docproc.c
rename to scripts/docproc.c
-- 
1.7.5.rc1



--------------060505030808060802080608--
