Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab2LTRsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 12:48:20 -0500
Received: from gloria.sntech.de ([95.129.55.99]:42472 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab2LTRsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 12:48:14 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Woody Wu <narkewoody@gmail.com>
Subject: Re: S3C2416 LCD Support
Date: Thu, 20 Dec 2012 18:48:17 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <20121220165623.GA7008@zuhnb712>
In-Reply-To: <20121220165623.GA7008@zuhnb712>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212201848.18219.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 20. Dezember 2012, 17:56:23 schrieb Woody Wu:
> Hi, List
> 
> Does the current kernel 3.7.1 support S3C2416 (it's *6* not 0) LCD and
> touch screen? I saw the help text of the CONFIG_FB_S3C says it only
> supports S3C6400 and S3C6410.

if you look in the mach-smd2416.c file you'll see that it uses the s3c-fb 
driver. I think the Kconfig text is just out of data, as the support for 
s3c2416 and s3c2443 was added later.

So it should work, but you'll have to try it for yourself :-)

As for the touchscreen, it probably depends on the type used.


Heiko
