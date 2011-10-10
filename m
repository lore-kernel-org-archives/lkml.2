Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1JJQpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:45:17 -0400
Received: from mail.ipax.at ([93.189.24.40]:41156 "EHLO mail.ipax.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab1JJQpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:45:15 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Oct 2011 12:45:15 EDT
Message-ID: <4E931F78.7050007@ipax.at>
Date: Mon, 10 Oct 2011 18:38:16 +0200
From: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Organization: IPAX Internet Services
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: trivial@kernel.org
CC: Borislav Petkov <bp@amd64.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: fix typos in Documentation/edac.txt and Documentation/filesystems/ext4.txt
References: <20111010163245.B6B4B281C28@ip52.ipax.at>
In-Reply-To: <20111010163245.B6B4B281C28@ip52.ipax.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing trivial typos in
Documentation/edac.txt and
Documentation/filesystems/ext4.txt

patch for current git head checkout from
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

Signed-off-by: Raoul Bhatia <r.bhatia@ipax.at>
---
diff --git a/Documentation/edac.txt b/Documentation/edac.txt
index 249822c..8ba7bb4 100644
--- a/Documentation/edac.txt
+++ b/Documentation/edac.txt
@@ -643,7 +643,7 @@ There is a three level tree beneath the above 'edac' 
directory. For example,
  the 'test_device_edac' device (found at the bluesmoke.sourceforget.net 
website)
  installs itself as:

-	/sys/devices/systm/edac/test-instance
+	/sys/devices/system/edac/test-instance

  in this directory are various controls, a symlink and one or more 
'instance'
  directorys.
diff --git a/Documentation/filesystems/ext4.txt 
b/Documentation/filesystems/ext4.txt
index 232a575..a8356c3 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -352,7 +352,7 @@ noinit_itable		Do not initialize any uninitialized 
inode table
  init_itable=n		The lazy itable init code will wait n times the
  			number of milliseconds it took to zero out the
  			previous block group's inode table.  This
-			minimizes the impact on the systme performance
+			minimizes the impact on the system performance
  			while file system's inode table is being initialized.

  discard			Controls whether ext4 should issue discard/TRIM

-- 
____________________________________________________________________
DI (FH) Raoul Bhatia M.Sc.          email.          r.bhatia@ipax.at
Technischer Leiter

IPAX - Aloy Bhatia Hava OEG         web.          http://www.ipax.at
Barawitzkagasse 10/2/2/11           email.            office@ipax.at
1190 Wien                           tel.               +43 1 3670030
FN 277995t HG Wien                  fax.            +43 1 3670030 15
____________________________________________________________________
