Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541Ab2HXOLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:11:38 -0400
Received: from nm10-vm0.bullet.mail.ird.yahoo.com ([77.238.189.90]:46133 "HELO
	nm10-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754172Ab2HXOLe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:11:34 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 861722.31806.bm@omp1033.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=BODomROUKE/OEOwD3YShEMiALjivHHNhY9YdzQw8yUZqreFpWRjWMhld4PslcmFI3/6JwM7gpUO/dFWX6ffXqOifRC447DMts8VLkqnMq0SUVIKDLsKi0lxwQemYZirq99NvMEJb4xO/zJwqiYfuLZQ4CC1EbD7Nbb2Oq8Ab3y0=;
X-YMail-OSG: aZsXtOMVM1nlLoRaogoPuFh.Q2OMI6xvwFHrdE0PUz7bL51
 OBGw9F4iv8Q91.8qtiwlYLwfveVsIewFcrTryZjognj4Zi.5VbQxzv8dzboI
 Xi8P6MYV4O3tmUMOwqPOs7KJIC_OJ87AaqwIFin70qhxh1iRdZbA2TJk9U8P
 j5bvORgLVPYBoV6k_O5RHbpwgrRQGsS9hvT1SPsyjQvLWF4pc6k.q5ryLoNd
 tcrkaF8RROae__osM8s1q3ANBHZ3iNFRlhUxKMRAhUbBGbdkdRgRF03fi.J_
 KWD0m3zsXgS5GRb2Bbrb_D8LrNmoAsOiBt5AtrHBIQ3KwYH.OCwlLEseo85v
 PiSfpGRLJChIR96uyddzhPsDaKyITQHztDt5cavUNvDeNBwN79qNZTNzmpBa
 PFO6MRBIbxZCYVfu2SQ8l.Hr24E3__DbPqni.w26nM15q12bkYrxm
X-Mailer: YahooMailWebService/0.8.121.416
Message-ID: <1345817492.27136.YahooMailNeo@web29603.mail.ird.yahoo.com>
Date: Fri, 24 Aug 2012 15:11:32 +0100 (BST)
From: "Bastelli Carlo \(yahoo\)" <carlo_bastelli@yahoo.it>
Reply-To: "Bastelli Carlo \(yahoo\)" <carlo_bastelli@yahoo.it>
Subject: SLAVE Side SPI kernel driver development
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "torvalds@osdl.org" <torvalds@osdl.org>
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
