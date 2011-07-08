Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab1GHTV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 15:21:58 -0400
Received: from nm25.bullet.mail.bf1.yahoo.com ([98.139.212.184]:23680 "HELO
	nm25.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754727Ab1GHTV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 15:21:56 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jul 2011 15:21:56 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 493833.38961.bm@omp1031.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=b+IXB6e6FbPsmAH7mvHXPwglNfP5Uee79LyvMpBSrXXLBCUTrjIcpiit82X/JGbNF/wJ/MAqSLUuZBXEbNgI/mmzhackzfZkWTEf+ET4UFyMvDlE2nQWiXn3nvSWF760akDB7WOdtcNdaztKFKat+f7RupManZ4ZmKKt5ijKXK0=;
X-YMail-OSG: e_2O.PAVM1nr.v7NQntsx.lZ1elDuy.Pzhpbiz9.Wy51l5J
 ayKxMKqPlPxlU3bDO5Q_Es3X.wgFyi78EiSPhIoDQXsAcH77xhVeb8EPz_mJ
 SoQ3TQJoawe1ZtGI1.6v_WKaPVGRUM7lSS2DvWlgC4ikBywZg2OaH4iirQjb
 NzYMVzzV1ElxxBDPwQFI_htYweYuchVneN37vd_6Lw50eCii9uiZwDWypDgv
 eubvUJmqtfkFsXYEudh4PSI4FoLJaKx_WHf86B1rDHRYxBIMYDbSEtHI1pGo
 htl5l8ruQKt0gyVEc6oU4MstJlyrHfw39jeE02i4KBZKdZ2EsviK2JsRfKHA
 6LfdSUMhzx769RjL68nkIjkbGhlNSb.Zb4N0rUK_gOQf9nHurIM_VN3E-
X-Mailer: YahooMailRC/572 YahooMailWebService/0.8.112.307740
Message-ID: <1310152571.74457.YahooMailRC@web161719.mail.bf1.yahoo.com>
Date: Fri, 8 Jul 2011 12:16:11 -0700 (PDT)
From: Peter Rasmussen <peterleifrasmussen@yahoo.com>
Subject: Support for exFAT fs in the kernel?
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ogawa-san,

Looking for the FAT relevant person in the MAINTAINERS file I found you.

It seems that more and more devices support high capacity SDXC flash cards that 
comes with the exFAT file system (aka FAT64), and I have recently acquired one 
myself, a Panasonic video camcorder, so I am interested in how the support is 
coming along in Linux?

I have a 64GB SDXC flashcard and if I format it eg. ext2 I can happily use it as 

an external storage chip in Linux, but every time I have gone around the 
Panasonic camera and acquired video that I would like to store on my Linux 
hosts, I can't go straight to them because of missing support for exFAT.

Please let me know if there is anything I can do, except actual development, as 
I am not a hard core Linux kernel developer, just a long time user.

I haven't subscribed to the kernel mailing list, so including a direct reply 
to me would be appreciated.

Best regards,
Peter
