Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab0LMR4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:56:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:45841 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757965Ab0LMR4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:56:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,336,1288594800"; 
   d="scan'208";a="867679822"
From: "Luck, Tony" <tony.luck@intel.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 13 Dec 2010 09:56:49 -0800
Subject: RE: [RFC] persistent store (version 3) (part 1 of 2)
Thread-Topic: [RFC] persistent store (version 3) (part 1 of 2)
Thread-Index: Acuauouh4uLlJmW6QFeSvsT9nLiUggAM3jkA
Message-ID: <987664A83D2D224EAE907B061CE93D530193BBAA27@orsmsx505.amr.corp.intel.com>
References: <AANLkTin2Z5XXf-3Gkqj72+FT4rM+hpqehK8Ys=gg++c9@mail.gmail.com>
In-Reply-To: <AANLkTin2Z5XXf-3Gkqj72+FT4rM+hpqehK8Ys=gg++c9@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>could you cc linux fs devel and maybe linux embedded mailing list?
>Currently I try to insert in mainline the pramfs. Maybe we have the
>same goal and we could "merge" our effort. What do you think? Sure the
>kernel from this point of view has got a lack of support, I see
>different approach and solution to this. I saw in the staging tree a
>pmem driver of google guys that it seems to be designed for the same
>goal.

Marco,

My Cc: list is already getting rather long ... I worry about
adding more mailing lists to it.  Embedded is a bit worrying
for me as I've been a bit cavalier about memory allocation in
the current version (on the theory that I was targeting servers,
and a few Kbytes, or even tens of Kbytes wasn't worth worrying
about on a server - which these days is likely to have a minimum
of 4 GBytes).

I grepped around for "pmem" in drivers/staging in linux-next and
got a lot of hits - but none of them leapt out as something
similar.  Can you point a bit more specifically?

-Tony
