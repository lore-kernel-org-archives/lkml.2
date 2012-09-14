Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab2INH5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 03:57:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53015 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab2INH5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 03:57:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH 1/2] ARM: SoC: convert MSM SMP to SoC descriptor
Date: Fri, 14 Sep 2012 07:57:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1347461906-13527-7-git-send-email-arnd@arndb.de> <201209130847.20087.arnd@arndb.de> <20120913161548.GA11395@codeaurora.org>
In-Reply-To: <20120913161548.GA11395@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209140757.34393.arnd@arndb.de>
X-Provags-ID: V02:K0:aw5FaUiSeFr5aK0zyWBSo3JPW5dNzbrCwgYWsmAYD5z
 sAC5oPgcgPsyMzCWrUuoxc0BcGXoA0AbxdtAhEDS5ho1Sp4mtN
 +gkfNdaGJ1NIqcnrxmgcts2CYNfz9xKBodko8SWl0esDl+nx/f
 MIM0HtcyUnwMI8YmRD0FfxE32rboBjGG6VWyD7FId4nGH56kia
 l1Jaf0jMaq37Fs0H3mBahKjvktHCiYEDGNkfq3P8yKQES2rQg/
 06FIqyMSi5nV+TRvRr79i/YbLwmG6tDgJIoHe2KVsHywyAYgbS
 rfsAhtaKZebZt5szHLVvgHR4uokoB91Eh2unggxRQ5ZVLtzyyD
 /kkSBfmiJ6TIE04jVK9k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2012, David Brown wrote:
> Olof wanted me to try and split the msm-for-3.7 into a few branches,
> so I'm going to work on that this morning.  I'm not quite sure how
> well it will work, since, for example, most of the cleanups are
> preparing the tree for the devicetree changes.

That is the common scenario. What you should do there is to have
one cleanup branch that collects all the cleanups from the other
branches, and then base each of the other branches on top of that.

	Arnd
