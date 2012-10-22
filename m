Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab2JVQ7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:59:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:10960 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab2JVQ7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:59:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,630,1344236400"; 
   d="scan'208";a="236863360"
Date: Mon, 22 Oct 2012 09:29:29 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v6
Message-ID: <20121022162929.GN2095@tassilo.jf.intel.com>
References: <1350665289-7288-1-git-send-email-andi@firstfloor.org>
 <CAHO5Pa0W-WGBaPvzdRJxYPdrg-K9guChswo3KJheK4BaRzsRwQ@mail.gmail.com>
 <20121022132733.GQ16230@one.firstfloor.org>
 <20121022133534.GR16230@one.firstfloor.org>
 <CAKgNAkgQ6JZdwOsCAQ4Ak_gVXtav=TzgzW2tbk5jMUwxtMqOAg@mail.gmail.com>
 <20121022153633.GK2095@tassilo.jf.intel.com>
 <CAKgNAki=AL+KdYDdYnE8ZhjK-tUf5cZ163BWPe6GRM0rpi-z7w@mail.gmail.com>
 <20121022161151.GS16230@one.firstfloor.org>
 <CAKgNAkjsGp9HUpvhUfqbXnfrLbBsQRAKvOs=41-w3ZAE7yX+cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkjsGp9HUpvhUfqbXnfrLbBsQRAKvOs=41-w3ZAE7yX+cA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since PowerPC already allows 16GB page sizes, doesn't there need to be
> allowance for the possibility of future expansion? Choosing a larger
> minimum size (like 2^16) would allow that. Does the minimum size need
> to be 16k? (Surely, if you want a HUGEPAGE, you want a bigger page
> than that? I am not sure.)

Some architectures have configurable huge page sizes, so it depends on
the user. I thought 16K is reasonable.  Can make it larger too. 

But I personally consider even 16GB pages somewhat too big.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
