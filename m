Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435Ab2K3S7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:59:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:58739 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758768Ab2K3S47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [ 44/56] get_dvb_firmware: fix download site for tda10046 firmware
Date: Fri, 30 Nov 2012 10:55:36 -0800
Message-Id: <20121130185122.844337903@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 25ec43d3e6306978cf66060ed18c4160ce8fc302 upstream.

The previous website doesn't exist anymore. Update it to one site that
actually exists.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/dvb/get_dvb_firmware |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -115,7 +115,7 @@ sub tda10045 {
 
 sub tda10046 {
 	my $sourcefile = "TT_PCI_2.19h_28_11_2006.zip";
-	my $url = "http://www.tt-download.com/download/updates/219/$sourcefile";
+	my $url = "http://technotrend.com.ua/download/software/219/$sourcefile";
 	my $hash = "6a7e1e2f2644b162ff0502367553c72d";
 	my $outfile = "dvb-fe-tda10046.fw";
 	my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);


