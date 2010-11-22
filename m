Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab0KVODf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 09:03:35 -0500
Received: from mail.ipax.at ([93.189.24.40]:40050 "EHLO mail.ipax.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab0KVODe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 09:03:34 -0500
X-Greylist: delayed 1430 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Nov 2010 09:03:34 EST
Message-ID: <4CEA729A.2070300@ipax.at>
Date: Mon, 22 Nov 2010 14:39:38 +0100
From: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de-DE; rv:1.9.2.13pre) Gecko/20101113 Shredder/3.1.7pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: fix typos in Documentation/edac.txt
Content-Type: multipart/mixed;
 boundary="------------050206020405010000090108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050206020405010000090108
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

hi,

attached, you will find a patch which fixes a couple of small typos
in edac.txt.

Signed-off-by: Raoul Bhatia <r.bhatia@ipax.at>

thanks,
raoul
-- 
____________________________________________________________________
DI (FH) Raoul Bhatia M.Sc.          email.          r.bhatia@ipax.at
Technischer Leiter

IPAX - Aloy Bhatia Hava OG          web.          http://www.ipax.at
Barawitzkagasse 10/2/2/11           email.            office@ipax.at
1190 Wien                           tel.               +43 1 3670030
FN 277995t HG Wien                  fax.            +43 1 3670030 15
____________________________________________________________________


--------------050206020405010000090108
Content-Type: text/x-diff;
 name="edac.txt.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="edac.txt.diff"

--- edac.txt.orig	2010-11-10 13:12:10.258355202 +0100
+++ edac.txt	2010-11-10 13:12:28.258737909 +0100
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


--------------050206020405010000090108--
