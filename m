Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab2HXO5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:57:14 -0400
Received: from nm5.bullet.mail.ird.yahoo.com ([77.238.189.62]:34250 "HELO
	nm5.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753038Ab2HXO5K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:57:10 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 58401.29264.bm@omp1013.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=l6TZdMHeOMwmDBoxKxNV/8fTQ2LGtL1BfkMK/nwQmuoZCBDTdfnmgHJ9cn2fEQr30kNYytAAxrdB0l/VmfH/i9+SiDeUpkbsCw3WHeUdI3++fCbEM6rqf39q1ae9KzBJhMS8gRb0Fx/Xvkt3UUIfoPPoR+ZUGAKrlWk604/irig=;
X-YMail-OSG: v1kxc2gVM1nYQ1kiIP.AgtKlD6vUFoXsP6CxU86_0ox9gXA
 0yLPs8StTxY3bogIKmp9uvn1sZekj1Q3hUDf8cr4JjjjtqDJ8m5ZkJA6A_Oq
 HSwGxolFX2CEbB2FEp9fRadWomlbpPRc_KY.5ESh6dBRuHCjnbwrpOklPMws
 IpQZfeVLtA.lRwI1dKFPY1sVxmvAHChwBCR_ysOvncihabv_TQhTvRja.5hM
 ixrljKfkyLNTcZyeBXGWC7hz0QBpa06m27xJr4rIWJCgTHuMwqc5HGGFi98j
 KECF0n5A7O_s9zh1OsNU9kXHHGRYxkauhM.FGZ95FwHwC7St51MfA2cUt8ut
 rwMX0wGpodByAAcYS9RHD.SyzVpz77PO.ISgb3dCMwslv40tNXkqmc_ARgoY
 7fZkDDwxFRUs3hHd98KNEfqRaSuuqnKQDBQ_lLgysU3AZ6YU83DyG
X-Mailer: YahooMailWebService/0.8.121.416
Message-ID: <1345820228.87750.YahooMailNeo@web29604.mail.ird.yahoo.com>
Date: Fri, 24 Aug 2012 15:57:08 +0100 (BST)
From: "Bastelli Carlo \(yahoo\)" <carlo_bastelli@yahoo.it>
Reply-To: "Bastelli Carlo \(yahoo\)" <carlo_bastelli@yahoo.it>
Subject: SLAVE Side SPI kernel driver development
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I'm Carlo, I have a difficult task at work, my boss asked me to 
develop
 a driver SPI slave side on embedded ARM processor running Linux. 
Precisely linux occur on the SPI bus as a slave, not master as required 
by the hierarchical structure of the current kernel. The new driver 
will
 receive via interrupt and respond when selected by its chip select. Can
 anyone suggest the best way to develop this driver?. Personally, I 
have identified two main roads, the first if possible to exploit the 
structure SPI master driver, with a few tricks that now I can not 
define. The second most radical, write a driver for a UART like, but 
managing the SPI device.
Thank you for any suggestions or examples.

Carlo Bastelli
