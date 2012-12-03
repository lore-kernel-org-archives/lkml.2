Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab2LCOnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:43:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43900 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755482Ab2LCOgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:54 -0500
Message-Id: <20121203143152.363434741@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:20 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 34/89] get_dvb_firmware: fix download site for tda10046 firmware
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 25ec43d3e6306978cf66060ed18c4160ce8fc302 upstream.

The previous website doesn't exist anymore. Update it to one site that
actually exists.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/dvb/get_dvb_firmware |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index 12d3952e..32bc56b 100755
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


