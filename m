Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab0KYPZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:25:41 -0500
Received: from mail.ipax.at ([93.189.24.40]:51417 "EHLO mail.ipax.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab0KYPZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:25:40 -0500
Message-ID: <4CEE7FF0.4090605@ipax.at>
Date: Thu, 25 Nov 2010 16:25:36 +0100
From: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de-DE; rv:1.9.2.13pre) Gecko/20101113 Shredder/3.1.7pre
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] trivial: fix typos in Documentation/edac.txt
References: <4CEA729A.2070300@ipax.at> <20101122144702.GA2704@kryptos.osrc.amd.com>
In-Reply-To: <20101122144702.GA2704@kryptos.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing trivial typos in edac.txt.
patch for linux-2.6.36.1.

Signed-off-by: Raoul Bhatia <r.bhatia@ipax.at>
---
--- Documentation/edac.txt.orig	2010-11-25 16:16:04.876600669 +0100
+++ Documentation/edac.txt	2010-11-10 13:12:28.258737909 +0100
@@ -196,7 +196,7 @@ csrow3.
 The representation of the above is reflected in the directory tree
 in EDAC's sysfs interface. Starting in directory
 /sys/devices/system/edac/mc each memory controller will be represented
-by its own 'mcX' directory, where 'X" is the index of the MC.
+by its own 'mcX' directory, where 'X' is the index of the MC.


 	..../edac/mc/
@@ -207,7 +207,7 @@ by its own 'mcX' directory, where 'X" is
 		   ....

 Under each 'mcX' directory each 'csrowX' is again represented by a
-'csrowX', where 'X" is the csrow index:
+'csrowX', where 'X' is the csrow index:


 	.../mc/mc0/
@@ -232,7 +232,7 @@ EDAC control and attribute files.


 In 'mcX' directories are EDAC control and attribute files for
-this 'X" instance of the memory controllers:
+this 'X' instance of the memory controllers:


 Counter reset control file:
@@ -343,7 +343,7 @@ Sdram memory scrubbing rate:
 'csrowX' DIRECTORIES

 In the 'csrowX' directories are EDAC control and attribute files for
-this 'X" instance of csrow:
+this 'X' instance of csrow:


 Total Uncorrectable Errors count attribute file:



-- 
____________________________________________________________________
DI (FH) Raoul Bhatia M.Sc.          email.          r.bhatia@ipax.at
Technischer Leiter

IPAX - Aloy Bhatia Hava OG          web.          http://www.ipax.at
Barawitzkagasse 10/2/2/11           email.            office@ipax.at
1190 Wien                           tel.               +43 1 3670030
FN 277995t HG Wien                  fax.            +43 1 3670030 15
____________________________________________________________________
