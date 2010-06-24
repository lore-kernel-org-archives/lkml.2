Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0FXQuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 12:50:09 -0400
Received: from web51007.mail.re2.yahoo.com ([206.190.38.138]:41009 "HELO
	web51007.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754272Ab0FXQuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 12:50:07 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jun 2010 12:50:07 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=kk9FwjRNqs4X6ypc/+lU2VodY7kbnUegwf2MsGooISo1QYB4PfYo/SkyOi69cQewNkl1hW+9iyE99EswVALV4+MHL8+3AOx05ScexcEVGDfGBafUqRdU7W0XDc3+7tpyfiGxXIjpmYgQc/cwkKZ+9lmwCjH53HUTmfvt7ka3zK0=;
Message-ID: <898714.83943.qm@web51007.mail.re2.yahoo.com>
X-YMail-OSG: tau8UFkVM1mqN5Yf8kb2huZFsbKWotMaIGPbQ9a6LURSpF2
 84TSRQmF67wcgGAjrhOe4X15Ew.Fc3I3hb1zWwJa0eDwyHOsspjogPepCTfg
 2Sj7n8LqanKnv96iTFd7SnAj9s2gqQgWJzkL.TwUqSH3JoML7xYsb_z0GFpt
 TC2s7dybaZ7sXbtI5G6.ny4XQWUaAncgKS86l4lmGyFXSvpnlDREhiRxwmgX
 bUsGLSF4Ny2FIXTZd3Zsxjuz9edpM4etI7.kiP9XC2y5Y0blfZ0TinLyaVgl
 qUPmf.bo6kefpHqwsm4sIXdXgOinXZZKSU.hSwbEdA3L11P3OFQ--
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.104.274457
Date: Thu, 24 Jun 2010 09:43:25 -0700 (PDT)
From: Fabio Estevam <fabioestevam@yahoo.com>
Subject: [PATCH] watchdog docs: add an entry for imx2_wdt
To: linux-kernel@vger.kernel.org
Cc: wim@iguana.be, rdunlap@xenotime.net, s.hauer@pengutronix.de,
       w.sang@pengutronix.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an entry for imx2_wdt in watchdog-parameters.txt

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 Documentation/watchdog/watchdog-parameters.txt |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Documentation/watchdog/watchdog-parameters.txt b/Documentation/watchdog/watchdog-parameters.txt
index 41c95cc..17ddd82 100644
--- a/Documentation/watchdog/watchdog-parameters.txt
+++ b/Documentation/watchdog/watchdog-parameters.txt
@@ -125,6 +125,11 @@ ibmasr:
 nowayout: Watchdog cannot be stopped once started
 	(default=kernel config parameter)
 -------------------------------------------------
+imx2_wdt:
+timeout: Watchdog timeout in seconds (default 60 s)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
 indydog:
 nowayout: Watchdog cannot be stopped once started
 	(default=kernel config parameter)
-- 
1.6.0.4




      
