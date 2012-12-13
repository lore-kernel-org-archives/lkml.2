Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab2LMOVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:21:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45084 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933392Ab2LMOOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:14:20 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 219/241] get_dvb_firmware: fix download site for tda10046 firmware
Date: Thu, 13 Dec 2012 11:59:44 -0200
Message-Id: <1355407206-17100-220-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 25ec43d3e6306978cf66060ed18c4160ce8fc302 upstream.

The previous website doesn't exist anymore. Update it to one site that
actually exists.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 Documentation/dvb/get_dvb_firmware |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index fbb2411..4d82210 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -116,7 +116,7 @@ sub tda10045 {
 
 sub tda10046 {
 	my $sourcefile = "TT_PCI_2.19h_28_11_2006.zip";
-	my $url = "http://www.tt-download.com/download/updates/219/$sourcefile";
+	my $url = "http://technotrend.com.ua/download/software/219/$sourcefile";
 	my $hash = "6a7e1e2f2644b162ff0502367553c72d";
 	my $outfile = "dvb-fe-tda10046.fw";
 	my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);
-- 
1.7.9.5

