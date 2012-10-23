Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab2JWNjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:39:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59854 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291Ab2JWNjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:39:53 -0400
Date: Tue, 23 Oct 2012 15:39:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v6
Message-ID: <20121023133952.GC16230@one.firstfloor.org>
References: <1350665289-7288-1-git-send-email-andi@firstfloor.org> <CAHO5Pa0W-WGBaPvzdRJxYPdrg-K9guChswo3KJheK4BaRzsRwQ@mail.gmail.com> <20121022132733.GQ16230@one.firstfloor.org> <20121022133534.GR16230@one.firstfloor.org> <CAKgNAkgQ6JZdwOsCAQ4Ak_gVXtav=TzgzW2tbk5jMUwxtMqOAg@mail.gmail.com> <20121022153633.GK2095@tassilo.jf.intel.com> <CAKgNAki=AL+KdYDdYnE8ZhjK-tUf5cZ163BWPe6GRM0rpi-z7w@mail.gmail.com> <1350956664.2728.19.camel@pasglop> <20121023022844.GQ2095@tassilo.jf.intel.com> <CAKgNAkh-OxXbc_s0yvF_SEce0JoTQhyPpGHwZikj9NpOjkJT4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkh-OxXbc_s0yvF_SEce0JoTQhyPpGHwZikj9NpOjkJT4w@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I thought further about this and I think the whole issue is a non issue
anyways: MAP_UNINITIALIZED is NOMMU only and HUGETLBFS is MMU only.
My flags only make sense with HUGETLBFS.

So they can never coexist anyways. So there is no reason to not overlap.

So I think the original patch is ok and doesn't need any change at all.

Sorry guys, if you really want to invent new syscalls please do it
yourself.

-Andi
