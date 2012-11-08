Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab2KHEHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 23:07:19 -0500
Received: from nm5-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.135]:25353 "EHLO
	nm5-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378Ab2KHEHR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 23:07:17 -0500
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2012 23:07:17 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 104548.6337.bm@omp1062.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=DK2mpc3V8DUqrIspI3xdipbTLcKY1GHgmDr90Y27l0EjRgl6rnApGrbntLZiQ4eejUhVBthd8SJExSaQQ/U4XCbHj826Rms4AAQoDwODmi4KQ0MqXj7Yww5jVtsvQX44RpuFFz4S1+xPQBM81lqhAW7UvU46RlLlYRGtqFwLKxI=;
X-YMail-OSG: 0ZbuV3kVM1l1G.ysco2G2CgKWPKUbmpWGnvmyD1IhXdAG_M
 0tzQubojYPHeCKphFeicSMjq0F79rRYUQejwKGDPOsQ1NT2YS98IZO4gMtnh
 z2eU5ZphbZrHL3uoQudl4s0KzUR_g5lO8kDMijo8gRsgN3jTOuCOCqEWO5AZ
 fotyxQSWzmLDWzDbvqW03ACuEbBCbijeIZGicd6tf0eWmWX4Dh8EyWk8YTaI
 YkHEeEh06eyJy6ZG1ew8y4JVgqYthWpYbLQveVAcuKqyhqEo13YyDLrJSDb.
 ux4koYiS16Q6ARUM8pkSdpurLpyda6XFCkfrE2FcMiraP21PXF75voD.kW6s
 cHK9eA0g_6T.4mIYBPKHdOgaY3cD3xwTbW1QH8ZIftcn_d2c9Dz1UbxGMgq7
 LyeyNByU4s5N0br72DVOw0XoresE3G.ezaCSXsopK.rYb6YDhn0g6fGiDqhE
 Fn4qjIGoRGxV_LJ_hQI2B4Xx.5mX14HxZCwLz3eemuTapkFdfsqRYkb.6lZb
 QQVc4
X-Rocket-MIMEInfo: 001.001,PiAKCj4gCj4gSGkgQWxleDoKCkhpLAoKPiAKPiBEbyB5b3UgaGF2ZSBhbnkgY29tbWVudCBvbiB0aGUgTUVNU1RJQ0sgcGFydCBpbiB0aGlzIHY3IHBhdGNoc2V0PyBDYW4gCj4geW91IGhlbHAgdG8gbWVyZ2UgdGhlIHBhdGNoIHRvIHRoZSBrZXJuZWwgdHJlZT8KCgpJJ20gYWZyYWlkIHRoYXQgcHJlc2VudGx5IEkgZG9uJ3QgaGF2ZSBtdWNoIHRpbWUgdG8gbG9vayBhdCB0aGUgbWVtc3RpY2sgcmVsYXRlZCBzdHVmZiBhbnkgZnVydGhlci4gSG9wZWZ1bGx5LCBzb21lYm9keSBlbHNlIGNhbiBzdGVwIGluIGEBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.123.460
References: <cover.1351481260.git.wei_wang@realsil.com.cn> <508F4A88.8010207@realsil.com.cn> <87r4o56w1f.fsf@octavius.laptop.org> <509B1FEA.1040505@realsil.com.cn>
Message-ID: <1352347282.60054.YahooMailNeo@web121002.mail.ne1.yahoo.com>
Date: Wed, 7 Nov 2012 20:01:22 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Reply-To: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH v7 0/3] Add modules to support realtek PCIE card reader
To: wwang <wei_wang@realsil.com.cn>, Chris Ball <cjb@laptop.org>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "bp@alien8.de" <bp@alien8.de>
In-Reply-To: <509B1FEA.1040505@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 

> 
> Hi Alex:

Hi,

> 
> Do you have any comment on the MEMSTICK part in this v7 patchset? Can 
> you help to merge the patch to the kernel tree?


I'm afraid that presently I don't have much time to look at the memstick related stuff any further. Hopefully, somebody else can step in and take a look at your submission.

Sorry for that.

> 
> Thanks.
> Wei WANG
>

Regards,
Alex
