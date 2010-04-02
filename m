Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209Ab0DBGsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 02:48:14 -0400
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:41984 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193Ab0DBGsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 02:48:04 -0400
MIME-Version: 1.0
In-Reply-To: <o2j28c262361004012213tc9fdebc7yc535f4130a86e644@mail.gmail.com>
References: <i2i5f4a33681003312105m4cd42e9ayfe35cc0988c401b6@mail.gmail.com>
	 <g2g5f4a33681004012051wedea9538w9da89e210b731422@mail.gmail.com>
	 <o2j28c262361004012213tc9fdebc7yc535f4130a86e644@mail.gmail.com>
Date: Fri, 2 Apr 2010 14:48:00 +0800
Message-ID: <y2r5f4a33681004012348q2b613930o6fc3c9d7060d9107@mail.gmail.com>
Subject: Re: [Question] race condition in mm/page_alloc.c regarding page->lru?
From: TAO HU <tghk48@motorola.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "Ye Yuan.Bo-A22116" <yuan-bo.ye@motorola.com>,
       Chang Qing-A21550 <Qing.Chang@motorola.com>,
       linux-arm-kernel@lists.infradead.org, Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Minchan Kim

It is hard to reproduce the problem.
We only observed it  twice in the past month.
And it randomly occurred a few more times before.

So I'm afraid neither git-bisect nor QEMU-goldfish would help.

On Fri, Apr 2, 2010 at 1:13 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Fri, Apr 2, 2010 at 12:51 PM, TAO HU <tghk48@motorola.com> wrote:
>> 2 patches related to page_alloc.c were applied.
>> Does anyone see a connection between the 2 patches and the panic?
>
> Seem to not related to the problem.
> I don't have seen the problem before.
>
> Could you git-bisect to make sure which patch makes bug?
> Is it reproducible?
> Can I reproduce it in QEMU-goldfish?
>
> --
> Kind regards,
> Minchan Kim
>
