Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab2FKO6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:58:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58188 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab2FKO6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:58:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH 8/14] ARM: LPC32xx: Clock adjustment for key matrix controller
Date: Mon, 11 Jun 2012 14:58:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
References: <1339412537-24485-1-git-send-email-stigge@antcom.de> <201206111416.19251.arnd@arndb.de> <4FD60203.8010103@antcom.de>
In-Reply-To: <4FD60203.8010103@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206111458.05546.arnd@arndb.de>
X-Provags-ID: V02:K0:sjxtiFo43uD3+hhmuNleSLEbhZWOxvL9Sdy1ImPe5p0
 F0ZPcTXj5pfI6edjYyWwlX/Ptrlh6FFlLgP/8oI4P7bxK675Hl
 qvV/W+9tLn6sR956GcwxoM4OIm0ICQwdLV5dXE7Mx/8tBqQOj4
 j50Dil4k5QRh6HiiSFrwGCnRgq8Nv9tXYpMIqPZMlYPIqqP3ti
 2oDZd+fd2WPNyOG7zFeP4EnUkefudxhBFuV11ILuoK7yy3U9ZI
 A/TCg8ygWHQ2HH3agwOou7qrMZ9Rp9CXjPNr5QwSFHRm4UCY1L
 gq1CoFIPY5XtTW/fr/fVEkJ+qlO/Btm36b7Z85f5LMQGIICIKA
 +qG5klCVTmldE1Itu9Qg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 June 2012, Roland Stigge wrote:
> On 06/11/2012 04:16 PM, Arnd Bergmann wrote:
> > On Monday 11 June 2012, Roland Stigge wrote:
> >> The clock.c file needs to be changed to match the automatic device name to its
> >> clock.
> >>
> >> Signed-off-by: Roland Stigge <stigge@antcom.de>
> >> Acked-by: Rob Herring <rob.herring@calxeda.com>
> >>
> > 
> > Should this not be in the same patch as the one that moves the device over
> > to DT probing? Otherwise you have a non-working setup if only one patch
> > is applied.
> 
> The actual driver is new for v3.6 (hopefully), DT-only.
> 
> Rather than merging the patches, I'd let the key driver go in via input,
> and the clock.c adjustment via arm-soc.

Ok, makes sense.

	Arnd
