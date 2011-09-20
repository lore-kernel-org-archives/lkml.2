Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1ITSqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:46:02 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61313 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1ITSp7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:45:59 -0400
MIME-Version: 1.0
In-Reply-To: <4E78CFC0.4020003@xenotime.net>
References: <20110920173102.d38155c7defbbc29beaae7c0@canb.auug.org.au>
	<4E78CFC0.4020003@xenotime.net>
Date: Tue, 20 Sep 2011 20:45:57 +0200
Message-ID: <CACna6rxGrd-ORWZrc0xsAOKptU_Xj3eGh9qSfX9vJYCPTZrCRg@mail.gmail.com>
Subject: Re: [PATCH -next] bcma: needs export.h
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/20 Randy Dunlap <rdunlap@xenotime.net>:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> bcma/driver_chipcommon_pmu.c needs to include <linux/export.h>,
> so add it to the headers that are included by bcma_private.h.

Please take a look at discussion in:
[PATCH -next] bcma: main.c needs to include <linux/slab.h>
thread (by Andrew).

I believe that according to the discussion, such a includes should be
done in .c files.

Andrew: can you comment? Am I right?

-- 
Rafał
