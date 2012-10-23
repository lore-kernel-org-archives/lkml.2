Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab2JWDBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 23:01:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:53319 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab2JWDBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 23:01:51 -0400
Message-ID: <1350956709.2728.20.camel@pasglop>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB
 v6
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: mtk.manpages@gmail.com
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hillf Danton <dhillf@gmail.com>
Date: Tue, 23 Oct 2012 12:45:09 +1100
In-Reply-To: <CAKgNAkjsGp9HUpvhUfqbXnfrLbBsQRAKvOs=41-w3ZAE7yX+cA@mail.gmail.com>
References: <1350665289-7288-1-git-send-email-andi@firstfloor.org>
	 <CAHO5Pa0W-WGBaPvzdRJxYPdrg-K9guChswo3KJheK4BaRzsRwQ@mail.gmail.com>
	 <20121022132733.GQ16230@one.firstfloor.org>
	 <20121022133534.GR16230@one.firstfloor.org>
	 <CAKgNAkgQ6JZdwOsCAQ4Ak_gVXtav=TzgzW2tbk5jMUwxtMqOAg@mail.gmail.com>
	 <20121022153633.GK2095@tassilo.jf.intel.com>
	 <CAKgNAki=AL+KdYDdYnE8ZhjK-tUf5cZ163BWPe6GRM0rpi-z7w@mail.gmail.com>
	 <20121022161151.GS16230@one.firstfloor.org>
	 <CAKgNAkjsGp9HUpvhUfqbXnfrLbBsQRAKvOs=41-w3ZAE7yX+cA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-22 at 18:23 +0200, Michael Kerrisk (man-pages) wrote:
> Since PowerPC already allows 16GB page sizes, doesn't there need to be
> allowance for the possibility of future expansion? Choosing a larger
> minimum size (like 2^16) would allow that. Does the minimum size need
> to be 16k? (Surely, if you want a HUGEPAGE, you want a bigger page
> than that? I am not sure.)

I can't say for sure what we're going to come up with in 5 years but so
far, I am not aware of plans to go beyond 16G just yet :-)

Cheers,
Ben.


