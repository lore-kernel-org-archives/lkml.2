Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab2JWBoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 21:44:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:37218 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512Ab2JWBow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 21:44:52 -0400
Message-ID: <1350956664.2728.19.camel@pasglop>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB
 v6
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: mtk.manpages@gmail.com
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hillf Danton <dhillf@gmail.com>
Date: Tue, 23 Oct 2012 12:44:24 +1100
In-Reply-To: <CAKgNAki=AL+KdYDdYnE8ZhjK-tUf5cZ163BWPe6GRM0rpi-z7w@mail.gmail.com>
References: <1350665289-7288-1-git-send-email-andi@firstfloor.org>
	 <CAHO5Pa0W-WGBaPvzdRJxYPdrg-K9guChswo3KJheK4BaRzsRwQ@mail.gmail.com>
	 <20121022132733.GQ16230@one.firstfloor.org>
	 <20121022133534.GR16230@one.firstfloor.org>
	 <CAKgNAkgQ6JZdwOsCAQ4Ak_gVXtav=TzgzW2tbk5jMUwxtMqOAg@mail.gmail.com>
	 <20121022153633.GK2095@tassilo.jf.intel.com>
	 <CAKgNAki=AL+KdYDdYnE8ZhjK-tUf5cZ163BWPe6GRM0rpi-z7w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-22 at 17:53 +0200, Michael Kerrisk (man-pages) wrote:

> This is all seems to make an awful muck of the API...

 .../...

> There seems to be a reasonable argument here for an mmap3() with a
> 64-bit flags argument...

I tend to agree. There's a similar issue happening when we try to shovel
things into protection bits, like we do with SAO (strong access
ordering) and want to do with per-page endian on embedded.

It think we need a pile of additional flag space.

Cheers,
Ben.

